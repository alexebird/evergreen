module Evergreen
  class Sequencer
    SEQUENCES = [
      [:blu_inc_point, ['Br', 'br']],

      [:red_inc_point, ['bR', 'br']],

      [:blu_dec_point, ['Br', 'BR', 'Br', 'br']],
      [:blu_dec_point, ['Br', 'BR', 'br']],
      #[:blu_dec_point, ['B', 'BR', 'B']],

      [:red_dec_point, ['bR', 'BR', 'bR', 'br']],
      [:red_dec_point, ['bR', 'BR', 'br']],
      #[:red_dec_point, ['R', 'BR', 'R']],

      #[:reset_points,  [['BR', 2]]],
    ]

    def initialize
      @events = []
    end

    def sequence(event)
      clear unless event
      @events << event

      #binding.pry
      if rv = full_match
        clear
        rv
      elsif partial_match?
        :partial
      else
        clear
      end
    end

    def clear
      @events = []
      nil
    end

    #@api private
    def seq_pattern(seq)
      seq[1]
    end

    # "does the pattern start with some list of events??"
    #private def pattern_start_with_events?(pattern, events)
      #pattern, events = [pattern, events].map{|coll| comparable_pattern_elements(coll) }
      #return true if events.empty?
      #(events.size).times do |i|
        #evt = events[i]
        #pat = pattern[i]
        #return true if !pat
        #if !(pat && pat[0] == evt[0] && evt[1] >= pat[1])
          #return false
        #end
      #end
      #return true
    #end

    #private def comparable_pattern_elements(events_or_sequence)
      #events_or_sequence.map do |e|
        #if e.is_a?(Event)
          #[e.mesg, e.duration]
        #elsif e.is_a?(Array)
          #e
        #else
          #[e, -1]
        #end
      #end
    #end

    def partial_match?
      !potential_matches.empty?
    end

    def potential_matches
      SEQUENCES.select { |ss| ss.last[0..(@events.size-1)] == @events.map(&:mesg)  }
    end

    def full_match
      potential_matches.detect do |potential|
        @events.size == seq_pattern(potential).size
      end
    end
  end
end
