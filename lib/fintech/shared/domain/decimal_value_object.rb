# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class DecimalValueObject < ValueObject
        value_type Types::Coercible::Decimal
      end
    end
  end
end
