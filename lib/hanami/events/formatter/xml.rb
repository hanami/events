require 'xmlsimple'

module Hanami
  module Events
    class Formatter
      # XML formatter for subscribed events.
      #
      # @since 0.1.0
      #
      # @api private
      class Xml
        def initialize(events_meta)
          # Accepts meta data of subscribed events
          #
          # @param events_meta [Hash] events meta data
          #
          # @since 0.1.0
          @events_meta = events_meta
        end

        # Returns events meta data in xml format
        #
        # @since 0.1.0
        def format
          XmlSimple.xml_out({ events: @events_meta })
        end
      end
    end
  end
end
