module Hanami
  module Events
    class Adapter
      class Memory
        attr_reader :events

        def initialize
          @events = {}
        end

        def push(event_name, payload)
          events[event_name] ||= []
          events[event_name] << payload
        end
      end
    end
  end
end
