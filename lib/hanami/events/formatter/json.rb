require 'json'

module Hanami
  module Events
    class Formatter
      # JSON formatter for subscribed events.
      #
      # @since 0.1.0
      #
      # @api private
      class Json
        def initialize(events_meta)
          # Accepts meta data of subscribed events
          #
          # @param events_meta [Hash] events meta data
          #
          # @since 0.1.0
          @events_meta = events_meta
        end

        # Returns events meta data in json format
        #
        # @since 0.1.0
        def format
          { events: @events_meta }.to_json
        end
      end
    end
  end
end
