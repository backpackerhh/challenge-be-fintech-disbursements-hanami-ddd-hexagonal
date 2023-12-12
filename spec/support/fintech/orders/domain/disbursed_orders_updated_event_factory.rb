# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersUpdatedEventFactory
        def self.build(attributes = {})
          DisbursedOrdersUpdatedEvent.from_primitives(
            {
              aggregate_id: DisbursedOrdersDisbursementIdFactory.build,
              aggregate_attributes: {
                order_ids: DisbursedOrdersIdsFactory.build
              },
              occurred_at: DisbursedOrdersOccurredAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
