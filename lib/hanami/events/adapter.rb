require 'dry/container'

module Hanami
  module Events
    # Adapter factory class.
    #
    # @since x.x.x
    #
    # @api private
    class Adapter
      extend Dry::Container::Mixin

      register(:memory_sync) do
        require_relative 'adapter/memory_sync'
        MemorySync
      end

      register(:memory_async) do
        require_relative 'adapter/memory_async'
        MemoryAsync
      end

      register(:redis) do
        require_relative 'adapter/redis'
        Redis
      end
    end
  end
end
