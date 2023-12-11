# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderEntityFactory
        Factory.define(:order) do |f|
          f.id { OrderIdFactory.build }
          f.merchant_id { OrderMerchantIdFactory.build }
          f.disbursement_id { OrderDisbursementIdFactory.build }
          f.amount { OrderAmountFactory.build }
          f.created_at { OrderCreatedAtFactory.build }
        end

        def self.build(*traits, **attributes)
          order = Factory.structs[:order, *traits, **attributes]

          OrderEntity.from_primitives(order.to_h)
        end

        def self.create(*traits, **attributes)
          order = Factory[:order, *traits, **attributes]

          OrderEntity.from_primitives(order.to_h)
        end
      end
    end
  end
end
