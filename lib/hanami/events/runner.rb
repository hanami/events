module Hanami
  module Events
    # Class for start subscribe loop runner
    class Runner
      attr_reader :event_instance, :options

      def initialize(event_instance, **options)
        @event_instance = event_instance
        @options = options
      end

      def start(options: {})
        logger.info "Running in #{RUBY_DESCRIPTION}"
        logger.info "Started server with #{event_instance.adapter.class} adapter"

        loop do
          event_instance.adapter.poll_subscribers
        end
      end

      def pause # or pause
      end

      def gracefully_shutdown
      end

      def force_shutdown!
      end

      def ready?
      end

      def healthy?
      end

      def print_debug_info(stream = STDOUT)
      end

      private

      def logger
        event_instance.adapter.logger || Logger.new(STDOUT)
      end
    end
  end
end
