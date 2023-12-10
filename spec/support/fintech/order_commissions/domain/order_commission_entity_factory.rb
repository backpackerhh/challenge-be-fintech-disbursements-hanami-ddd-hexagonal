# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionEntityFactory
        Factory.define(:order_commission) do |f|
          f.id { OrderCommissionIdFactory.build }
          f.order_id { OrderCommissionOrderIdFactory.build }
          f.order_amount { OrderCommissionOrderAmountFactory.build }
          f.fee { |order_amount| OrderCommissionFeeFactory.build(order_amount) }
          f.amount { |order_amount| OrderCommissionAmountFactory.build(order_amount) }
          f.created_at { OrderCommissionCreatedAtFactory.build }
        end

        def self.build(*traits, **attributes)
          order_commission = Factory.structs[:order_commission, *traits, **attributes]

          OrderCommissionEntity.from_primitives(order_commission.to_h)
        end

        def self.create(*traits, **attributes)
          order_commission = Factory[:order_commission, *traits, **attributes]

          OrderCommissionEntity.from_primitives(order_commission.to_h)
        end
      end
    end
  end
end
