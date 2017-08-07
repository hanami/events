require_relative 'base'

module Hanami
  module Events
    class Adapter
      class Memory < Base
        def initialize(logger: nil, **)
          @logger = logger
          @subscribers = []
          @event_queue = Queue.new
        end

        def broadcast(event_name, payload)
          @event_queue << { name: event_name, payload: payload }
        end

        private

        def spawn_thread!
          Thread.new do
            loop { call_subscribers }
          end
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
