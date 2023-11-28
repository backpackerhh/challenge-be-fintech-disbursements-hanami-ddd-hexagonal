# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class CreateOrderUseCase < Shared::Application::UseCase
        repository "orders.repository", type: Domain::OrderRepository::Interface
        logger

        def create(attributes)
          order = Domain::OrderEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(order.to_primitives)

          logger.info("Order successfully created")
        end
      end
    end
  end
end
