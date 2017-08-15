require 'dry/container'

module Hanami
  module Events
    # Formatter for subscribed events.
    #
    # @since x.x.x
    #
    # @api private
    class Formatter
      extend Dry::Container::Mixin

      register(:plain_text) do
        require_relative 'formatter/plain_text'
        PlainText
      end

      register(:json) do
        require_relative 'formatter/json'
        Json
      end
    end
  end
end
