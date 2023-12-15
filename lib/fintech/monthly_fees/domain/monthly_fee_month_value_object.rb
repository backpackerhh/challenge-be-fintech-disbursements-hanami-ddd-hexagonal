# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeMonthValueObject < Shared::Domain::StringValueObject
        value_type Types::Strict::String.constrained(size: 7, format: /\A\d{4}-\d{2}\z/)
      end
    end
  end
end
