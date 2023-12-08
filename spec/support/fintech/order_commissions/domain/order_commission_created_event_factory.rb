# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionCreatedEventFactory
        def self.build(attributes = {})
          OrderCommissionCreatedEvent.from_primitives(
            {
              aggregate_id: OrderCommissionIdFactory.build,
              aggregate_attributes: {
                order_id: OrderCommissionOrderIdFactory.build,
                order_amount: OrderCommissionOrderAmountFactory.build,
                amount: OrderCommissionAmountFactory.build
              },
              occurred_at: OrderCommissionCreatedAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
