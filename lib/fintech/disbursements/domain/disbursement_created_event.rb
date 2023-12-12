# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementCreatedEvent < Shared::Domain::Event
        def self.from(disbursement)
          from_primitives(
            aggregate_id: disbursement.id.value,
            aggregate_attributes: {
              amount: disbursement.amount.value,
              merchant_id: disbursement.merchant_id.value,
              order_ids: disbursement.order_ids.value,
              reference: disbursement.reference.value
            },
            occurred_at: disbursement.created_at.value
          )
        end
      end
    end
  end
end
