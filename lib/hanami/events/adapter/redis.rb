require 'json'

module Hanami
  module Events
    class Adapter
      class Redis
        attr_reader :listeners

        def initialize(redis:)
          @redis = redis
        end

        def announce(event_name, payload)
          @redis.publish("hanami-events.#{event_name}", payload.to_json)
        end

        def subscribe_pattern(event_name, &block)
          Thread.new do
            listener = Listener.new(event_name, block)

            @redis.with do |connection|
              connection.subscribe("hanami-events.#{event_name}") do |on|
                on.message { |channel, msg| listener.call(event_name, JSON.parse(msg)) }
              end
            end
          end
        end
      end
    end
  end
end
