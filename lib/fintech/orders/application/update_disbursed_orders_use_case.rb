# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class UpdateDisbursedOrdersUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface
        logger
        event_bus "domain_events.async_bus"

        def update_disbursed(order_ids, disbursement_id)
          repository.bulk_update_disbursed(order_ids, disbursement_id)

          logger.info("Orders successfully updated for disbursement #{disbursement_id}: #{order_ids}")

          event_bus.publish(Domain::DisbursedOrdersUpdatedEvent.from(order_ids, disbursement_id))
        end
      end
    end
  end
end
