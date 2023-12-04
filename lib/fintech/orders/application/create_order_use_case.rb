# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class CreateOrderUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface
        logger
        event_bus

        def create(attributes)
          order = Domain::OrderEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(order.to_primitives)

          logger.info("Order #{order.id.value} successfully created")

          event_bus.publish(Domain::OrderCreatedEvent.from(order))
        end
      end
    end
  end
end
