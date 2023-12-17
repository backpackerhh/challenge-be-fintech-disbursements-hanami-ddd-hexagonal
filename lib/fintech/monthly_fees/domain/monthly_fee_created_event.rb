# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeCreatedEvent < Shared::Domain::Event
        def self.from(monthly_fee)
          from_primitives(
            aggregate_id: monthly_fee.id.value,
            aggregate_attributes: {
              merchant_id: monthly_fee.merchant_id.value,
              amount: monthly_fee.amount.value,
              commissions_amount: monthly_fee.commissions_amount.value,
              month: monthly_fee.month.value
            },
            occurred_at: monthly_fee.created_at.value
          )
        end
      end
    end
  end
end
