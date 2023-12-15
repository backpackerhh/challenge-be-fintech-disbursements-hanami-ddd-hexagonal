# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeMonthFactory
        def self.build(value)
          value.strftime("%Y-%m")
        end
      end
    end
  end
end
