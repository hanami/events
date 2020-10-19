# frozen_string_literal: true

require "dry/container"

module Hanami
  module Events
    # Serializer factory class.
    class Serializer
      extend Dry::Container::Mixin

      register(:json) do
        require_relative "serializer/json"
        Json
      end
    end
  end
end
