require_relative 'adapter/memory'
require_relative 'adapter/redis'

module Hanami
  module Events
    class Adapter
      def self.build(adapter_name, options)
        case adapter_name
        when :memory then Memory.new
        when :redis then Redis.new(**options)
        else
          Memory.new
        end
      end
    end
  end
end
