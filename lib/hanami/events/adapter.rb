require_relative 'adapter/memory'

module Hanami
  module Events
    class Adapter
      def self.build(adapter_name, options)
        Memory.new
      end
    end
  end
end
