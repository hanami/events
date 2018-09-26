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
        DEFAULT_STREAM = 'hanami.events'.freeze
        EVENT_STORE = 'hanami.event_store'.freeze

        attr_reader :subscribers, :logger

        def initialize(params)
          @redis = with_connection_pool(params[:redis])
          @logger = params[:logger]
          @subscribers = []
          @stream = params.fetch(:stream, DEFAULT_STREAM)
          @thread_spawned = false
          @serializer = params.fetch(:serializer, :json).to_sym
        end

        # Brodcasts event to all subscribes
        #
        # @param event [Symbol, String] the event name
        # @param payload [Hash] the event data
        #
        # @since 0.1.0
        def broadcast(event_name, payload)
          @redis.with do |conn|
            conn.lpush(
              @stream,
              serializer.serialize(
                id: SecureRandom.uuid,
                event_name: event_name,
                payload: payload
              )
            )
          end
        end

        # Subscribes block for selected event
        #
        # @param event_name [Symbol, String] the event name
        # @param block [Block] to execute when event is broadcasted
        #
        # @since 0.1.0
        def subscribe(event_name, _kwargs = EMPTY_HASH, &block) # rubocop:disable Metrics/MethodLength
          @subscribers << Subscriber.new(event_name, block, @logger)
        end

        # Method for call all subscribers in one time
        #
        # @since 0.2.0
        def poll_subscribers
          @redis.with do |conn|
            message = conn.brpoplpush(@stream, EVENT_STORE)
            call_subscribers(
              serializer.deserialize(message)
            )
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

        def with_connection_pool(redis)
          return redis if redis.is_a?(ConnectionPool)
          raise ArgumentError, 'Please, provide an instance of Redis' unless redis.is_a?(::Redis)

          ConnectionPool.new(size: 5, timeout: 5) { redis }
        end

        def serializer
          Hanami::Events::Serializer[@serializer].new
        end
      end
    end
  end
end
