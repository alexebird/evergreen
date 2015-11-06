module Evergreen
  class Socket < UDPSocket
    def initialize
      super
      @synthesizer = Synthesizer.new
      @sequencer = Sequencer.new
    end

    # @api private
    def log(msg, ts=false)
      if ts
        $stdout.puts(format('%s: %s', Time.now, msg))
      else
        $stdout.puts(msg)
      end
    end

    def bind(host='localhost', port=8888)
      log format('evergreen bound to udp://%s:%d', host, port)
      super(host, port)
    end

    # @api private
    def read_payload
      recvfrom(2)[0]
    end

    def listen
      loop do
        pld = Payload.new(read_payload)
        if event = @synthesizer.synthesize(pld)
          if seq = @sequencer.sequence(event)
            yield(seq)
          end
        end
      end
    end
  end
end
