require 'json'

module Hanami
  module Events
    class Serializer
      # Simple serializer for json format
      class Json
        def serialize(event)
          event.to_json
        end

        def deserialize(message)
          JSON.parse(message)
        end
      end
    end
  end
end
