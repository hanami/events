module Hanami
  module Events
    # Base event class with public methods
    #
    # @since 0.1.0
    #
    # @api public
    class Base
      attr_reader :adapter

      def initialize(adapter_name, options)
        @adapter = Adapter[adapter_name.to_sym].new(options)
      end

      # Brodcasts event to all subscribes
      #
      # @param event [Symbol, String] the event name
      # @param payload [Hash] the event data
      #
      # @since 0.1.0
      def broadcast(event)
        adapter.broadcast(event)
      end

      # Calls subscribes for selected adapter
      #
      # @param event_name [Symbol, String] the event name
      #
      # @since 0.1.0
      def subscribe(event_name, &block)
        adapter.subscribe(event_name, &block)
      end

      # Returns all events subscribed for current instance
      #
      # @since 0.1.0
      def subscribed_events
        adapter.subscribers.map(&:meta)
      end

      # Returns formatted events
      #
      # @param type [Symbol] the format type
      #
      # @since 0.1.0
      def format(type)
        Formatter[type].new(subscribed_events).format
      end
    end
  end
end
