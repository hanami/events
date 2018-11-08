require 'dry-struct'
require 'shallow_attributes'


class EventObjects
  class Pure
    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def ==(other)
      self.user_id == other.user_id
    end
  end

  module Types
    include Dry::Types.module
  end

  class Struct < Dry::Struct
    attribute :user_id, Types::Coercible::Integer
  end

  class Shallow
    include ShallowAttributes

    attribute :user_id, Integer
  end
end
