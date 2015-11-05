module Evergreen
  class Payload
    include Comparable
    attr_reader :value, :ts

    def initialize(val)
      @value, @ts = val, Time.now.utc
    end

    def <=>(other)
      value <=> other.value
    end
  end

  class Synthesizer
    def initialize
      @last_payload = @curr_payload = nil
    end

    def synthesize(payload)
      raise('nil payload') unless payload
      update_payloads(payload)

      if state_change?
        mk_events
      else
        nil
      end
    end

    # @api private
    def state_change?
      return false unless @curr_payload
      @last_payload != @curr_payload
    end

    # @api private
    def update_payloads(new_payload)
      @last_payload = @curr_payload
      @curr_payload = new_payload
    end

    # @api private
    def mk_events
      Event.new(@curr_payload.value)
    end
  end
end
