# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementCreatedEventFactory
        def self.build(attributes = {})
          DisbursementCreatedEvent.from_primitives(
            {
              aggregate_id: DisbursementIdFactory.build,
              aggregate_attributes: {
                amount: DisbursementAmountFactory.build,
                merchant_id: DisbursementMerchantIdFactory.build,
                reference: DisbursementReferenceFactory.build,
                order_ids: DisbursementOrderIdsFactory.build
              },
              occurred_at: DisbursementCreatedAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
