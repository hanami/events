module Hanami
  module Events
    # Class for start subscribe loop runner
    class Runner
      attr_reader :event_instance, :options, :pool

      def initialize(event_instance, **options)
        @event_instance = event_instance
        @options = options
      end

      def start(threads: 5)
        logger.info "Running in #{RUBY_DESCRIPTION}"
        logger.info "Started server with #{event_instance.adapter.class} adapter"

        @pool = Concurrent::ThreadPoolExecutor.new(
          max_queue: 10, min_threads: 1, max_threads: threads, fallback_policy: :discard
        )

        loop do
          if pool.running?
            pool.post { event_instance.adapter.pull_subscribers }
          end

          return if pool.shutdown?
        end

        pool.wait_for_termination
      end

      def gracefully_shutdown
        logger.info "Shoutdown server"
        pool.shutdown
      end

      def force_shutdown!
        pool.kill
      end

      def running?
        pool.running?
      end

      def shuttingdown?
        pool.shuttingdown?
      end

      def shutdown?
        pool.shutdown?
      end

      private

      def logger
        event_instance.adapter.logger || Logger.new(STDOUT)
      end
    end
  end
end
