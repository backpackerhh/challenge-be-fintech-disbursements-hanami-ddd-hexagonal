# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class EventBus
        Interface = Types::Interface(:publish)

        include Deps[event_subscribers: "domain_events.subscribers"]

        attr_reader :event_subscriptions

        def initialize(...)
          super(...)

          @event_subscriptions = Hash.new { |hash, key| hash[key] = [] }

          event_subscribers.each do |event_subscriber_klass|
            event_subscriber = event_subscriber_klass.new

            event_subscriber.subscribed_to.each do |event_klass|
              @event_subscriptions[event_klass] << event_subscriber
            end
          end
        end
      end
    end
  end
end
