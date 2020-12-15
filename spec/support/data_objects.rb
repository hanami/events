require 'dry-struct'
require 'shallow_attributes'


class EventObjects
  class Pure
    attr_reader :user_id

    def initialize(opts)
      @user_id = opts[:user_id]
    end

    def ==(other)
      self.user_id == other.user_id
    end
  end

  module Types
    include Dry::Types()
  end

  class Struct < Dry::Struct
    attribute :user_id, Types::Coercible::Integer
  end

  class Shallow
    include ShallowAttributes

    attribute :user_id, Integer
  end
end
