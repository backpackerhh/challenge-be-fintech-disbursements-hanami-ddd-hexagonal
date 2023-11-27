# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderEntityFactory
        Factory.define(:order) do |f|
          f.id { Fintech::Orders::Domain::OrderIdFactory.build }
          f.merchant_id { Fintech::Orders::Domain::OrderMerchantIdFactory.build }
          f.amount { Fintech::Orders::Domain::OrderAmountFactory.build }
          f.created_at { Fintech::Orders::Domain::OrderCreatedAtFactory.build }
        end

        def self.build(attributes = {})
          order = Factory.structs[:order, **attributes]

          OrderEntity.from_primitives(order.to_h)
        end

        def self.create(attributes = {})
          order = Factory[:order, **attributes]

          OrderEntity.from_primitives(order.to_h)
        end
      end
    end
  end
end
