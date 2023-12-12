# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Application::UpdateDisbursedOrdersOnDisbursementCreatedEventSubscriber,
               type: %i[event_subscriber database] do
  it "is included in the list of event subscribers" do
    expect(Fintech::Container["domain_events.subscribers"]).to include(described_class)
  end

  describe "#on(event)" do
    it "updates orders with the disbursement extracted from given event" do
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      order_a = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        disbursement_id: nil
      )
      order_b = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        disbursement_id: nil
      )
      disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
        merchant_id: merchant.id.value,
        order_ids: [order_a.id.value, order_b.id.value]
      )
      disbursement_created_event = Fintech::Disbursements::Domain::DisbursementCreatedEvent.from(disbursement)
      event_subscriber = described_class.new

      event_subscriber.on(disbursement_created_event)

      expect(order_a.disbursement_id.value).to eq(disbursement.id.value)
      expect(order_b.disbursement_id.value).to eq(disbursement.id.value)
    end
  end

  describe "#subscribed_to" do
    it "includes the list of events" do
      event_subscriber = described_class.new

      expect(event_subscriber.subscribed_to).to \
        contain_exactly(Fintech::Disbursements::Domain::DisbursementCreatedEvent)
    end
  end
end
