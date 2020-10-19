# frozen_string_literal: true

require "dry/container"

module Hanami
  module Events
    # Formatter for subscribed events.
    #
    # @since 0.1.0
    #
    # @api private
    class Formatter
      extend Dry::Container::Mixin

      register(:plain_text) do
        require_relative "formatter/plain_text"
        PlainText
      end

      register(:json) do
        require_relative "formatter/json"
        Json
      end

      register(:xml) do
        require_relative "formatter/xml"
        Xml
      end
    end
  end
end
