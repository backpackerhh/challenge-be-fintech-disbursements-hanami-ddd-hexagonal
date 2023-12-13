# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersUpdatedEvent < Shared::Domain::Event
        def self.from(order_ids, disbursement_id)
          from_primitives(
            aggregate_id: disbursement_id,
            aggregate_attributes: {
              order_ids:
            },
            occurred_at: Time.now
          )
        end
      end
    end
  end
end
