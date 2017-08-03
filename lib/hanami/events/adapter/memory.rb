module Hanami
  module Events
    class Adapter
      class Memory
        attr_reader :subscribers

        def initialize(**)
          @subscribers = []
        end

        def broadcast(event_name, payload)
          @subscribers.each do |subscriber|
            subscriber.call(event_name, payload)
          end
        end

        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block)
        end
      end
    end
  end
end
