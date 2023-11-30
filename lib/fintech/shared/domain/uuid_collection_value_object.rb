# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class UuidCollectionValueObject < ValueObject
        value_type Types::Coercible::Array.of(Types::Strict::String.constrained(uuid_v4: true))
      end
    end
  end
end
