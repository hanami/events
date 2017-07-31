module Hanami
  module Events
    class Base
      attr_reader :adapter

      def initialize(adapter_name, options)
        @adapter = Adapter.build(adapter_name, options)
      end
    end
  end
end
