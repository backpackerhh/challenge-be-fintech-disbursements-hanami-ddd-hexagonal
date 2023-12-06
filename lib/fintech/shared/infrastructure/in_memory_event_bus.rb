# frozen_string_literal: true

module Fintech
  module Shared
    module Infrastructure
      class InMemoryEventBus < Domain::EventBus
        def publish(event)
          event_subscriptions[event.class].each { |subscriber| subscriber.on(event) }
        end
      end
    end
  end
end
