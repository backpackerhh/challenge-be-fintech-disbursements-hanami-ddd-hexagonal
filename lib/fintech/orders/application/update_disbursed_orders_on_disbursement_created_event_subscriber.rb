# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class UpdateDisbursedOrdersOnDisbursementCreatedEventSubscriber < Shared::Domain::EventSubscriber
        include Deps["logger"]

        def on(event)
          logger.info("Event #{event.id} successfully received")

          UpdateDisbursedOrdersUseCase.new.update_disbursed(
            event.aggregate_attributes.fetch(:order_ids),
            event.aggregate_id
          )
        end

        def subscribed_to
          [Disbursements::Domain::DisbursementCreatedEvent]
        end
      end
    end
  end
end
