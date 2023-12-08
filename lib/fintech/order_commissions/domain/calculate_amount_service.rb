# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class CalculateAmountService < Shared::Domain::Service
        attribute :order_amount, Types::Params::Decimal

        def amount
          (order_amount * ExtractFeeService.new(order_amount:).fee / 100).ceil(2)
        end
      end
    end
  end
end
