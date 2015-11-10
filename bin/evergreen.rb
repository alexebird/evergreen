#!/usr/bin/ruby

begin
  # use `bundle install --standalone' to get this...
  require_relative '../bundle/bundler/setup'
#rescue LoadError
  # fall back to regular bundler if the developer hasn't bundled standalone
  #require 'bundler'
  #Bundler.setup
end

require 'awesome_print'
require 'pry-byebug'
require 'daemons'

#binding.pry

$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib'))
require 'evergreen'

puts 'daemonizing...'
Daemons.daemonize

logf = ARGV[0]
$logout = logf ? File.open(logf, 'w') : $stdout

sock = Evergreen::Socket.new
sock.bind
sock.listen do |seq|
  $logout.puts "seq=#{seq.inspect}"
end

loop do
  touch '~/bird/tmp/hi'
  sleep 1
end
