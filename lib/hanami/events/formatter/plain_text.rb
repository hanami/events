module Hanami
  module Events
    class Formatter
      # Plain text formatter for subscribed events.
      #
      # @since 0.1.0
      #
      # @api private
      class PlainText
        # Accepts meta data of subscribed events
        #
        # @param events_meta [Hash] events meta data
        #
        # @since 0.1.0
        def initialize(events_meta)
          @events_meta = events_meta
        end

        # Returns events meta data in plain text format
        #
        # @since 0.1.0
        def format
          "Events:\n#{formatted_events}"
        end

        private

        def formatted_events
          @events_meta.map { |e| "\t#{e[:name].inspect}" }.join("\n")
        end
      end
    end
  end
end
