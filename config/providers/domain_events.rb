# frozen_string_literal: true

Hanami.app.register_provider :domain_events, namespace: true do
  prepare do
    Dir[target.root.join("lib/fintech/**/*_event_subscriber.rb")].each { |file| require file }

    register "subscribers", Fintech::Shared::Domain::EventSubscriber.subclasses
  end

  start do
    register "bus", Fintech::Shared::Infrastructure::InMemoryEventBus.new
  end
end
