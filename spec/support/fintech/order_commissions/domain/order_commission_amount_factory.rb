# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionAmountFactory
        def self.build(value)
          CalculateAmountService.new(order_amount: value).amount
        end
      end
    end
  end
end
