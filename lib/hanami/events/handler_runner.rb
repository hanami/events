module Hanami
  module Events
    class HandlerRunner
      attr_reader :logger

      def initialize(handler, logger)
        @handler = handler
        @logger = logger
      end

      def call(payload)
        instance_exec(payload, &@handler)
      end
    end
  end
end
