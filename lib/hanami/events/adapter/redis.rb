require 'json'
require 'securerandom'

module Hanami
  module Events
    class Adapter
      class Redis
        STREAM_NAME = 'hanami.events'
        EVENT_STORE = 'hanami.event_store'

        attr_reader :subscribers

        def initialize(params)
          @redis = params[:redis]
          @logger = params[:logger]
          @subscribers = []
          @thread_spawned = false
        end

        def broadcast(event_name, payload)
          @redis.with do |conn|
            conn.lpush(STREAM_NAME, {
              id: SecureRandom.uuid,
              event_name: event_name,
              payload: payload
            }.to_json)
          end
        end

        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            loop do
              @redis.with do |conn|
                message = conn.brpoplpush(STREAM_NAME, EVENT_STORE)
                call_subscribers(JSON.parse(message))
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

        def call_subscribers(message)
          @subscribers.each { |subscriber| subscriber.call(message['event_name'], message['payload']) }
        end
      end
    end
  end
end
