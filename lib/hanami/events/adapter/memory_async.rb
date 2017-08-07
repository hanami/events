module Hanami
  module Events
    class Adapter
      class MemoryAsync
        attr_reader :subscribers

        def initialize(logger: nil, **)
          @logger = logger
          @subscribers = []
          @event_queue = Queue.new
        end

        def broadcast(event_name, payload)
          @event_queue << { name: event_name, payload: payload }
        end

        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            loop { call_subscribers }
          end
        end

        private

        def thread_spawned?
          @thread_spawned
        end

        def thread_spawned!
          @thread_spawned = true
        end

        def call_subscribers
          event = @event_queue.pop

          @subscribers.each do |subscriber|
            subscriber.call(event[:name], event[:payload])
          end
        end
      end
    end
  end
end
