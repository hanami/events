require 'dry/container'

module Hanami
  module Events
    class Formatter
      extend Dry::Container::Mixin

      register(:plain_text) do
        require_relative 'formatter/plain_text'
        PlainText
      end

      register(:json) do
        require_relative 'formatter/plain_text'
        PlainText
      end
    end
  end
end
