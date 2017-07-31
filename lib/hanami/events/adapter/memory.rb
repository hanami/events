module Hanami
  module Events
    class Adapter
      class Memory
        attr_reader :listeners

        def initialize
          @listeners = []
        end

        def announce(event_name, payload)
          @listeners.map { |listener| listener.call(event_name, payload) }
        end

        def subscribe_pattern(event_name, &block)
          @listeners << Listener.new(event_name, block)
        end
      end
    end
  end
end
