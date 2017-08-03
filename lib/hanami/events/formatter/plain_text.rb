module Hanami
  module Events
    class Formatter
      class PlainText
        def initialize(data)
          @data = data
        end

        def format
          "Events:\n#{formatted_events}"
        end

        private

        def formatted_events
          @data.map { |d| "\t#{d[:title].inspect}" }.join("\n")
        end
      end
    end
  end
end
