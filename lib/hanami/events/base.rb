module Hanami
  module Events
    # Base event class with public methods
    #
    # @since x.x.x
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
      # @since x.x.x
      def broadcast(event, **payload)
        adapter.broadcast(event, payload)
      end

      # Calls subscribes for selecterd adapter
      #
      # @param event_name [Symbol, String] the event name
      #
      # @since x.x.x
      def subscribe(event_name, &block)
        adapter.subscribe(event_name, &block)
      end

      # Returns all events subscribed for current instance
      #
      # @since x.x.x
      def subscribed_events
        adapter.subscribers.map(&:meta)
      end

      # Returns formatted events
      #
      # @param type [Symbol] the format type
      #
      # @since x.x.x
      def format(type)
        Formatter[type].new(subscribed_events).format
      end
    end
  end
end
