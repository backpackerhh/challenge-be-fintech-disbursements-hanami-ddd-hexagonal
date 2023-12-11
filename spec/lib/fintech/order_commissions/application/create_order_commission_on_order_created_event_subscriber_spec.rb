# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::OrderCommissions::Application::CreateOrderCommissionOnOrderCreatedEventSubscriber,
               type: %i[event_subscriber database] do
  it "is included in the list of event subscribers" do
    expect(Fintech::Container["domain_events.subscribers"]).to include(described_class)
  end

  describe "#on(event)" do
    it "creates an order commission from given event" do
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
      order_created_event = Fintech::Orders::Domain::OrderCreatedEvent.from(order)
      event_subscriber = described_class.new

      order_commissions = Fintech::Container["order_commissions.repository"].all

      expect(order_commissions.map(&:id)).to eq([])

      event_subscriber.on(order_created_event)

      order_commissions = Fintech::Container["order_commissions.repository"].all.map do |oc|
        [oc.order_id.value, oc.order_amount.value]
      end

      expect(order_commissions).to contain_exactly(
        [order.id.value, order.amount.value]
      )
    end
  end

  describe "#subscribed_to" do
    it "includes the list of events" do
      event_subscriber = described_class.new

      expect(event_subscriber.subscribed_to).to contain_exactly(Fintech::Orders::Domain::OrderCreatedEvent)
    end
  end
end
