# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class UpdateDisbursedOrdersOnDisbursementCreatedEventSubscriber < Shared::Domain::EventSubscriber
        include Deps["logger"]

        def on(event)
          logger.info("Event #{event.id} successfully received")

          # TODO
        end

        def subscribed_to
          [Disbursements::Domain::DisbursementCreatedEvent]
        end
      end
    end
  end
end
