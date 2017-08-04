module Hanami
  module Events
    class Formatter
      class PlainText
        def initialize(events_meta)
          @events_meta = events_meta
        end

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
