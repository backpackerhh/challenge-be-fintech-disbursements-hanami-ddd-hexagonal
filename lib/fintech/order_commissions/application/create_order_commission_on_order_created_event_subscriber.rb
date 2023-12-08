# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Application
      class CreateOrderCommissionOnOrderCreatedEventSubscriber < Shared::Domain::EventSubscriber
        include Deps["logger"]

        def on(event)
          logger.info("Event #{event.id} successfully received")

          CreateOrderCommissionUseCase.new.create(
            order_id: event.aggregate_id,
            order_amount: event.aggregate_attributes.fetch(:amount)
          )
        end

        def subscribed_to
          [Orders::Domain::OrderCreatedEvent]
        end
      end
    end
  end
end
