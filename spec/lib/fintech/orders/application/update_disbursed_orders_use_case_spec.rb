# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Application::UpdateDisbursedOrdersUseCase, type: :use_case do
  describe "#update_disbursed(order_ids, disbursement_id)" do
    let(:repository) { Fintech::Orders::Infrastructure::InMemoryOrderRepository.new }
    let(:event_bus) { Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new }
    let(:order_ids) { %w[52f063bf-f2c9-4404-8ea7-bc4a05fe5ef1 b20614f8-7005-4afa-8404-6fce6fca846b] }
    let(:disbursement_id) { "f5692003-612d-475b-b112-c3bb641e57a3" }

    it "updates them with the expected disbursement" do
      use_case = described_class.new(repository:, event_bus:)

      expect(repository).to receive(:bulk_update_disbursed).with(order_ids, disbursement_id)

      use_case.update_disbursed(order_ids, disbursement_id)
    end

    it "publishes an event about orders marked as disbursed", freeze_time: Time.now do
      use_case = described_class.new(repository:, event_bus:)

      expect(event_bus).to receive(:publish).with(
        Fintech::Orders::Domain::DisbursedOrdersUpdatedEventFactory.build(
          aggregate_id: disbursement_id,
          aggregate_attributes: {
            order_ids:
          },
          occurred_at: Time.now
        )
      )

      use_case.update_disbursed(order_ids, disbursement_id)
    end
  end
end
