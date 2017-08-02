require 'dry/container'

module Hanami
  module Events
    class Adapter
      extend Dry::Container::Mixin

      register(:memory) do
        require_relative 'adapter/memory'
        Memory
      end

      register(:redis) do
        require_relative 'adapter/redis'
        Redis
      end
    end
  end
end
