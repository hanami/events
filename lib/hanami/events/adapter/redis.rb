require 'json'

module Hanami
  module Events
    class Adapter
      class Redis
        EVENTS_NAME = 'hanami_event'

        attr_reader :listeners

        def initialize(redis:)
          @redis = redis
          @listeners = []
          @uniq_thread = false
        end

        def announce(event_name, payload)
          @redis.publish(EVENTS_NAME, payload.to_json)
        end

        def subscribe_pattern(event_name, &block)
          @listeners << Listener.new(event_name, block)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            @redis.with do |connection|
              connection.subscribe(EVENTS_NAME) do |on|
                on.message { |_, message| call_listeners(event_name, message)  }
              end
            end
          end
        end

        private

        def thread_spawned?
          @thread_spawned
        end

        def thread_spawned!
          @thread_spawned = true
        end

        def subscribe_to_events(connection)
        end

        def call_listeners(event_name, message)
          @listeners.each { |listener| listener.call(event_name, JSON.parse(message)) }
        end
      end
    end
  end
end
