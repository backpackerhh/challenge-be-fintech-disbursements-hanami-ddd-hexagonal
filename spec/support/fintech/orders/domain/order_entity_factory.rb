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

          f.trait :disbursed do |d|
            d.disbursement_id { Fintech::Orders::Domain::OrderDisbursementIdFactory.build }
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
