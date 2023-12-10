# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderEntityFactory
        Factory.define(:order) do |f|
          f.id { OrderIdFactory.build }
          f.merchant_id { OrderMerchantIdFactory.build }
          f.amount { OrderAmountFactory.build }
          f.created_at { OrderCreatedAtFactory.build }

          f.trait :disbursed do |d|
            d.disbursement_id { OrderDisbursementIdFactory.build }
          end
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
