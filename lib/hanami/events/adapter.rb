require_relative 'adapter/memory'

module Hanami
  class Events
    class Adapter
      def self.build(adapter_name, options)
        Memory.new
      end
    end
  end
end
