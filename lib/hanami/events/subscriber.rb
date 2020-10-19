# frozen_string_literal: true

module Hanami
  module Events
    # Subscriber class for calling subscriber blocks
    #
    # @since 0.1.0
    #
    # @api private
    class Subscriber
      # @since 0.1.0
      #
      # @api private
      class Runner
        attr_reader :logger, :map_to

        def initialize(handler, logger)
          @handler = handler
          @logger = logger
        end

        def call(payload)
          instance_exec(payload, &@handler)
        end
      end

      def initialize(event_name, event_handler, logger = nil, data_struct_class = nil)
        @event_name = event_name
        @pattern_matcher = Matcher.new(event_name)
        @runner = Runner.new(event_handler, logger)
        @data_struct_class = data_struct_class
      end

      # Call runner with payload if event match by subscribe pattern
      #
      # @param event_name [String] the event name
      # @param payload [Hash] the payload
      #
      # @since 0.1.0
      #
      # @api private
      def call(event_name, payload)
        return unless @pattern_matcher.match?(event_name)

        data_object = @data_struct_class ? @data_struct_class.new(payload) : payload
        @runner.call(data_object)
      end

      # Returns meta information for subscriber
      #
      # @since 0.1.0
      #
      # @api private
      def meta
        {name: @event_name}
      end
    end
  end
end
