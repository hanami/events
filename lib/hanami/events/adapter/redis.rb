require 'json'
require_relative 'base'

module Hanami
  module Events
    class Adapter
      class Redis < Base
        CHANNEL = 'hanami_events'

        def initialize(redis:, logger: nil, **params)
          @logger = logger
          @redis = redis
          @subscribers = []
        end

        def broadcast(event_name, payload)
          @redis.with do |conn|
            conn.publish(CHANNEL, { event_name: event_name, **payload }.to_json)
          end
        end

        private

        def spawn_thread!
          Thread.new do
            @redis.with do |conn|
              conn.subscribe(CHANNEL) do |on|
                on.message { |_, message| call_subscribers(JSON.parse(message)) }
              end
            end
          end
        end

        def call_subscribers(payload)
          event_name = payload.delete('event_name')
          @subscribers.each { |subscriber| subscriber.call(event_name, payload) }
        end
      end
    end
  end
end
