# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantMinimumMonthlyFeeFactory
        def self.build(value = rand(20))
          value
        end
      end
    end
  end
end
