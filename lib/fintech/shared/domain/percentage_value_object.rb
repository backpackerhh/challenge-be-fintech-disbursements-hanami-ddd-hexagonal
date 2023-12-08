# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class PercentageValueObject < ValueObject
        value_type Types::Params::Decimal.constrained(gteq: 0.0, lteq: 100.0)
      end
    end
  end
end
