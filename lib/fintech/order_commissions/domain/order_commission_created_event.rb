# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionCreatedEvent < Shared::Domain::Event
        def self.from(order_commission)
          from_primitives(
            aggregate_id: order_commission.id.value,
            aggregate_attributes: {
              order_id: order_commission.order_id.value,
              order_amount: order_commission.order_amount.value,
              amount: order_commission.amount.value
            },
            occurred_at: order_commission.created_at.value
          )
        end
      end
    end
  end
end
