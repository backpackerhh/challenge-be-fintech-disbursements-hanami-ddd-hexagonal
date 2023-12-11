# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Application::FindDisbursableMerchantsUseCase, type: :use_case do
  describe "#retrieve_grouped_ids" do
    let(:repository) { Fintech::Merchants::Infrastructure::InMemoryMerchantRepository.new }

    it "returns grouped disbursable merchants" do
      use_case = described_class.new(repository:)
      grouped_disbursable_merchant_ids = {
        Fintech::Merchants::Domain::MerchantDisbursementFrequencyFactory.daily => %w[
          98ca396b-b15d-4dbd-9327-5c5c5eec0b8a
          65493247-b6ee-4c81-bbc4-96a09db0a717
        ]
      }

      allow(repository).to receive(:grouped_disbursable_ids).and_return(grouped_disbursable_merchant_ids)

      result = use_case.retrieve_grouped_ids

      expect(result).to eq(grouped_disbursable_merchant_ids)
    end
  end
end
