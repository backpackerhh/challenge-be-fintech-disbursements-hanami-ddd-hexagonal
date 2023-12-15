# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeCommissionsAmountFactory
        def self.build(value = rand(20), percentage = 0.15)
          value * percentage
        end
      end
    end
  end
end
