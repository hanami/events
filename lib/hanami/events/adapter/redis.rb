require 'json'

module Hanami
  module Events
    class Adapter
      class Redis
        CHANNEL = 'hanami_events'

        attr_reader :subscribers

        def initialize(params)
          @redis = params[:redis]
          @subscribers = []
        end

        def broadcast(event_name, payload)
          @redis.publish(CHANNEL, { event_name: event_name, **payload }.to_json)
        end

        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            @redis.with do |connection|
              connection.subscribe(CHANNEL) do |on|
                on.message { |_, message| call_subscribers(JSON.parse(message)) }
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

        def call_subscribers(payload)
          event_name = payload.delete('event_name')
          @subscribers.each { |subscriber| subscriber.call(event_name, payload) }
        end
      end
    end
  end
end
