# frozen_string_literal: true

module Fintech
  module Shared
    module Infrastructure
      class SidekiqEventBus < Domain::EventBus
        def publish(event)
          event_subscriptions[event.class].each do |subscriber|
            PublishEventJob.perform_async(subscriber.class.name, EventSerializer.serialize(event))
          end
        end
      end
    end
  end
end
