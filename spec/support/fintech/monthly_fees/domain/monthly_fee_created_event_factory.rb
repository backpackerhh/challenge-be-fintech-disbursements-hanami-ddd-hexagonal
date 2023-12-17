# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeCreatedEventFactory
        def self.build(attributes = {})
          MonthlyFeeCreatedEvent.from_primitives(
            {
              aggregate_id: MonthlyFeeIdFactory.build,
              aggregate_attributes: {
                merchant_id: MonthlyFeeMerchantIdFactory.build,
                amount: MonthlyFeeAmountFactory.build,
                commissions_amount: MonthlyFeeCommissionsAmountFactory.build,
                month: MonthlyFeeMonthFactory.build(Date.today)
              },
              occurred_at: MonthlyFeeCreatedAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
