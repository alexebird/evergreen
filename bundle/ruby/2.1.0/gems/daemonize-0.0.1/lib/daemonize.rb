require 'daemonize/version'

module Daemonize
  # The code that will actually daemonize a process. It is
  # based on the coding rules specified in the 13th chapter
  # in [Advanced Programming in the UNIX Environment] [1]
  # and the `daemons` Ruby gem.
  #
  # [1]: http://www.amazon.com/dp/0321525949/
  #
  # The goals of this method are to:
  #
  # 1. Set the file mask to 0
  # 2. Fork and exit the parent
  # 3. Create a new session with setsid
  # 4. Change the working directory
  # 5. Close unneeded file descriptors
  # 6. Reopen standard files
  #
  # The default logging facility is set to be the system
  # log, since this application is supposed to be rather
  # chatty.
  #
  # The method yields once the process has been daemonized.
  #
  # Example usage:
  #
  #     start_daemon :pid_file => "app.pid" do
  #       EM.run {
  #         # code
  #       }
  #     end
  def start_daemon(opts = {})
    app_name = opts[:app_name] 
    pid_file = opts[:pid_file]
    cwd      = opts[:cwd]

    # The inhereted file mask might deny some permissions.
    File.umask(0000)

    # Start the actual daemon
    Process.fork do
      # Detach the child process from the parent's session.
      Process.setsid

      # Re-fork. This is recommended for System V-based
      # system as it guarantees that the daemon is not a
      # session leader, which prevents it from aquiring
      # a controlling terminal under the System V rules.
      exit if fork

      # Change the working directory. Otherwise, if the
      # daemon was started in a mounted partition, it
      # might prevent it from being unmounted.
      Dir.chdir(cwd)

      # Rename the process
      $0 = app_name

      # Store the process ID in a file
      open(pid_file, "w") { |f| f.write(Process.pid) }

      # Trap the QUIT signal
      trap(:QUIT) do
        Syslog.crit "Received QUIT signal"
        # Make sure there's a pid file to delete
        Syslog.crit "Removing the pid file"
        File.delete(pid_file) if File.exists?(pid_file)

        Syslog.crit "Exiting..."

        exit
      end

      # Close unneeded file descriptors since some might
      # be inhereted from the parent process.
      ObjectSpace.each_object(IO) do |io|
        unless [ $stderr, $stdout, $stdin ].include?(io)
          io.close unless io.closed?
        end
      end

      # Flush all buffers
      $stdout.sync = $stderr.sync = true

      # Set all standard files to `/dev/null/` in order
      # to be sure that any output from the daemon will
      # not appear in any terminals.
      $stdin.reopen("/dev/null")
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")

      # Use the system log to record activity and errors 
      # since opening a regular file to log events is not
      # appropiate for daemons.
      Syslog.open
      Syslog.crit "Starting #{app_name}..."

      yield
    end
  end

  # Stop a running daemon by specifying the PID file. It 
  # returns true or false if the process was successfully 
  # stopped.
  #
  # Example usage:
  # 
  #     stop_daemon :pid_file => file
  def stop_daemon(opts = {})
    pid_file = opts[:pid_file]

    unless File.exists?(pid_file)
      return false
    end

    pid = File.read(pid_file).to_i

    begin
      Process.kill(:QUIT, pid)
    rescue Errno::ESRCH
      # The process does not exist
      return false
    end

    File.delete(pid_file)
  end
end
