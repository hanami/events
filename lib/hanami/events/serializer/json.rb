require 'json'

module Hanami
  module Events
    class Serializer
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
