# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionEntityFactory
        Factory.define(:order_commission) do |f|
          f.id { Fintech::OrderCommissions::Domain::OrderCommissionIdFactory.build }
          f.order_id { Fintech::OrderCommissions::Domain::OrderCommissionOrderIdFactory.build }
          f.order_amount { Fintech::OrderCommissions::Domain::OrderCommissionOrderAmountFactory.build }
          f.fee do |order_amount|
            Fintech::OrderCommissions::Domain::OrderCommissionFeeFactory.build(order_amount)
          end
          f.amount do |order_amount|
            Fintech::OrderCommissions::Domain::OrderCommissionAmountFactory.build(order_amount)
          end
          f.created_at { Fintech::OrderCommissions::Domain::OrderCommissionCreatedAtFactory.build }
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
