require 'json'
require 'securerandom'

module Hanami
  module Events
    class Adapter
      # Redis Adapter
      #
      # @since 0.1.0
      #
      # @api private
      class Redis
        DEFAULT_STREAM = 'hanami.events'
        EVENT_STORE = 'hanami.event_store'

        attr_reader :subscribers

        def initialize(params)
          @redis = with_connection_pool(params[:redis])
          @logger = params[:logger]
          @subscribers = []
          @stream = params.fetch(:stream, DEFAULT_STREAM)
          @thread_spawned = false
        end

        # Brodcasts event to all subscribes
        #
        # @param event
        #
        # @since 0.1.0
        def broadcast(event)
          @redis.with do |conn|
            conn.lpush(@stream, {
              id: SecureRandom.uuid,
              class: event.class,
              attributes: event.to_h
            }.to_json)
          end
        end

        # Subscribes block for selected event
        #
        # @param event_name [Symbol, String] the event name
        # @param block [Block] to execute when event is broadcasted
        #
        # @since 0.1.0
        def subscribe(event_name, &block)
          @subscribers << Subscriber.new(event_name, block, @logger)

          return if thread_spawned?
          thread_spawned!

          Thread.new do
            loop do
              @redis.with do |conn|
                message = conn.brpoplpush(@stream, EVENT_STORE)
                event_attributes = JSON.parse(message)

                event_class = Module.const_get("::#{event_attributes["class"]}")
                attributes = symbolize_keys(event_attributes["attributes"])

                call_subscribers(event_class.new(attributes))
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

        def call_subscribers(event)
          @subscribers.each { |subscriber| subscriber.call(event) }
        end

        def with_connection_pool(redis)
          return redis if redis.is_a?(ConnectionPool)
          raise ArgumentError, 'Please, provide an instance of Redis' unless redis.is_a?(::Redis)

          ConnectionPool.new(size: 5, timeout: 5) { redis }
        end

        def symbolize_keys(attributes)
          attributes.each_with_object({}) { |(k, v), hash| hash[k.to_sym] = v }
        end
      end
    end
  end
end
