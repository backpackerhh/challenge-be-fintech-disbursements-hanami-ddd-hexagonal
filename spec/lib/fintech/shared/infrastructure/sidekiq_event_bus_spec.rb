# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Shared::Infrastructure::SidekiqEventBus, type: :event_bus do
  describe "#event_subscribers" do
    it "returns the list of default event subscribers" do
      event_bus = described_class.new

      expect(event_bus.event_subscribers).to eq(Fintech::Container["domain_events.subscribers"])
    end

    it "returns the list of given event subscribers" do
      event_subscribers = [Fintech::Shared::Application::FakeEventSubscriber]
      event_bus = described_class.new(event_subscribers:)

      expect(event_bus.event_subscribers).to eq(event_subscribers)
    end
  end

  describe "#event_subscriptions" do
    it "returns all events and their subscribers" do
      event_subscribers = [Fintech::Shared::Application::FakeEventSubscriber]
      event_bus = described_class.new(event_subscribers:)

      expect(event_bus.event_subscriptions).to match(
        {
          Fintech::Shared::Domain::FakeEvent => [instance_of(Fintech::Shared::Application::FakeEventSubscriber)]
        }
      )
    end
  end

  describe "publish(event)" do
    it "provides given event to all its subscribers", :sidekiq_inline do
      event_subscribers = [Fintech::Shared::Application::FakeEventSubscriber]
      event_subscriber = Fintech::Shared::Application::FakeEventSubscriber.new
      event = Fintech::Shared::Domain::FakeEvent.new(
        aggregate_id: SecureRandom.uuid,
        aggregate_attributes: {
          a: 1,
          b: 2
        },
        occurred_at: Time.now
      )

      allow(Fintech::Shared::Application::FakeEventSubscriber).to receive(:new).and_return(event_subscriber)

      event_bus = described_class.new(event_subscribers:)

      expect(event_subscriber).to receive(:on).with(event)

      event_bus.publish(event)
    end

    it "raises an exception when event data is not as expected" do
      event_subscribers = [Fintech::Shared::Application::FakeEventSubscriber]
      event = Fintech::Shared::Domain::FakeEvent.new(
        aggregate_id: "uuid",
        aggregate_attributes: {},
        occurred_at: Time.now
      )
      event_bus = described_class.new(event_subscribers:)

      expect { event_bus.publish(event) }.to raise_error(Fintech::Shared::Domain::InvalidEventSchemaError)
    end
  end
end
