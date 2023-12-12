# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Application::GroupDisbursableOrdersUseCase, type: :use_case do
  describe "#retrieve_grouped" do
    let(:repository) { Fintech::Orders::Infrastructure::InMemoryOrderRepository.new }

    it "returns grouped disbursable merchants" do
      use_case = described_class.new(repository:)
      grouping_type = "daily"
      merchant_id = "98ca396b-b15d-4dbd-9327-5c5c5eec0b8a"
      grouped_disbursable_orders = [
        {
          start_date: "2023-04-14",
          end_date: "2023-04-14",
          order_ids: %w[
            98ca396b-b15d-4dbd-9327-5c5c5eec0b8a
            65493247-b6ee-4c81-bbc4-96a09db0a717
          ],
          amount: BigDecimal("123.45"),
          commissions_amount: BigDecimal("1.24")
        },
      ]

      allow(repository).to receive(:group).with(grouping_type, merchant_id).and_return(grouped_disbursable_orders)

      result = use_case.retrieve_grouped(grouping_type, merchant_id)

      expect(result).to eq(grouped_disbursable_orders)
    end
  end
end
