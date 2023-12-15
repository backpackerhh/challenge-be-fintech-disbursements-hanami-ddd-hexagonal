# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeEntityFactory
        Factory.define(:monthly_fee, relation: :monthly_fees) do |f|
          f.id { MonthlyFeeIdFactory.build }
          f.merchant_id { MonthlyFeeMerchantIdFactory.build }
          f.amount { MonthlyFeeAmountFactory.build }
          f.commissions_amount { |amount| MonthlyFeeCommissionsAmountFactory.build(amount) }
          f.created_at { MonthlyFeeCreatedAtFactory.build }
          f.month { |created_at| MonthlyFeeMonthFactory.build(created_at) }
        end

        def self.build(*traits, **attributes)
          monthly_fee = Factory.structs[:monthly_fee, *traits, **attributes]

          MonthlyFeeEntity.from_primitives(monthly_fee.to_h)
        end

        def self.create(*traits, **attributes)
          monthly_fee = Factory[:monthly_fee, *traits, **attributes]

          MonthlyFeeEntity.from_primitives(monthly_fee.to_h)
        end
      end
    end
  end
end
