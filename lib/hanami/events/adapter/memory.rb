module Hanami
  module Events
    class Adapter
      class Memory
        attr_reader :events, :listeners

        def initialize
          @events = {}
          @listeners = []
        end

        def push(event_name, payload)
          events[event_name] ||= []
          events[event_name] << payload
        end

        def subscribe_pattern(event_name, &block)
          @listeners << Listener.new(event_name, block)
        end
      end
    end
  end
end
