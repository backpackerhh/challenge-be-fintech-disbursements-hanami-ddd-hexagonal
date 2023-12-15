# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class CreateOrderUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface
        logger
        event_bus "domain_events.async_bus"
        finder_use_case "merchants.find.use_case"

        def create(attributes)
          attributes = attributes.transform_keys(&:to_sym)
          merchant_id = attributes.fetch(:merchant_id)

          finder_use_case.find(merchant_id)

          order = Domain::OrderEntity.from_primitives(attributes)

          repository.create(order.to_primitives)

          logger.info("Order #{order.id.value} successfully created for merchant #{merchant_id}")

          event_bus.publish(Domain::OrderCreatedEvent.from(order))
        end
      end
    end
  end
end
