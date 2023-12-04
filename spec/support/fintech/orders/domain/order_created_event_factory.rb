# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderCreatedEventFactory
        def self.build(attributes = {})
          OrderCreatedEvent.from_primitives(
            {
              aggregate_id: OrderIdFactory.build,
              aggregate_attributes: {
                amount: OrderAmountFactory.build,
                merchant_id: OrderMerchantIdFactory.build
              },
              occurred_at: OrderCreatedAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
