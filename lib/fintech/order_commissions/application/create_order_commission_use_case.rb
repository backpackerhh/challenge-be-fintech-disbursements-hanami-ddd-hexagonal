# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Application
      class CreateOrderCommissionUseCase < Shared::Application::UseCase
        repository "order_commissions.repository", Domain::OrderCommissionRepository::Interface
        logger
        event_bus
        finder_use_case "orders.find.use_case"

        def create(attributes)
          attributes = attributes.transform_keys(&:to_sym)
          order_id = attributes.fetch(:order_id)

          finder_use_case.find(order_id)

          if repository.exists?(order_id:)
            raise Domain::AlreadyExistingOrderCommissionError, "Order #{order_id} already has a commission associated"
          end

          order_commission = Domain::OrderCommissionEntity.from_primitives(attributes)

          repository.create(order_commission.to_primitives)

          logger.info("Order commission #{order_commission.id.value} successfully created")

          event_bus.publish(Domain::OrderCommissionCreatedEvent.from(order_commission))
        end
      end
    end
  end
end
