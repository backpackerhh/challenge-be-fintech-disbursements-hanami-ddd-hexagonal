# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderCreatedEvent < Shared::Domain::Event
        def self.from(order)
          new(
            aggregate_id: order.id.value,
            aggregate_attributes: {
              amount: order.amount.value,
              merchant_id: order.merchant_id.value
            },
            occurred_at: order.created_at.value
          )
        end
      end
    end
  end
end
