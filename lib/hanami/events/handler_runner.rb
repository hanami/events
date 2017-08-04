module Hanami
  module Events
    class HandlerRunner
      attr_reader :logger

      def initialize(event_handler, logger)
        @event_handler = event_handler
        @logger = logger
      end

      def call(payload)
        instance_exec(payload, &@event_handler)
      end
    end
  end
end
