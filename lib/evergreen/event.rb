module Evergreen
  class Event
    include Comparable
    attr_reader :type, :mesg
    attr_accessor :duration

    def initialize(mesg)
      @mesg = mesg
      #@sender_addr = udp_payload.last
    end

    def to_s
      #inspect
      mesg
      format('%s for %.2fs', mesg, duration || -1.0)
    end

    def <=>(other)
      mesg <=> other.mesg
    end
  end
end
