# frozen_string_literal: true

module Hanami
  module Events
    class Adapter
      # Synchronous Memory Adapter
      #
      # @since 0.1.0
      #
      # @api private
      class MemorySync
        attr_reader :subscribers, :logger

        def initialize(logger: nil, **)
          @logger = logger
          @subscribers = Concurrent::Array.new
        end

        # Brodcasts event to all subscribes
        #
        # @param event [Symbol, String] the event name
        # @param payload [Hash] the event data
        #
        # @since 0.1.0
        def broadcast(event_name, payload)
          @subscribers.map do |subscriber|
            subscriber.call(event_name, payload)
          end
        end

        # Subscribes block for selected event
        #
        # @param event_name [Symbol, String] the event name
        # @param block [Block] to execute when event is broadcasted
        #
        # @since 0.1.0
        def subscribe(event_name, kwargs = EMPTY_HASH, &block)
          @subscribers << Subscriber.new(event_name, block, @logger, kwargs[:map_to])
        end

        # Method for call all subscribers in one time
        #
        # @since 0.2.0
        def pull_subscribers
          true
        end
      end
    end
  end
end
