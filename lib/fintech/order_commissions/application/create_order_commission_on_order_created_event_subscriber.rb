# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Application
      class CreateOrderCommissionOnOrderCreatedEventSubscriber < Shared::Domain::EventSubscriber
        def on(event)
        end

        def subscribed_to
          [Orders::Domain::OrderCreatedEvent]
        end
      end
    end
  end
end
