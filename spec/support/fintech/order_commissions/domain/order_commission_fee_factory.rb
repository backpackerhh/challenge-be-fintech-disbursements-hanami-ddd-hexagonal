# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionFeeFactory
        def self.build(value)
          ExtractFeeService.new(order_amount: value).fee
        end
      end
    end
  end
end
