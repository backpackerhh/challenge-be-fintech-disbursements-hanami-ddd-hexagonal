# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeAmountFactory
        def self.build(value = rand(20))
          value
        end
      end
    end
  end
end
