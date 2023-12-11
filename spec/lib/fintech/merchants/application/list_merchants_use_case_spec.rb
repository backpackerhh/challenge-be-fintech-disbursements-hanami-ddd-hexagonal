# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Application::ListMerchantsUseCase, type: :use_case do
  describe "#retrieve_all" do
    let(:repository) { Fintech::Merchants::Infrastructure::InMemoryMerchantRepository.new }

    it "returns all merchants" do
      use_case = described_class.new(repository:)
      merchants = [
        Fintech::Merchants::Domain::MerchantEntityFactory.build,
        Fintech::Merchants::Domain::MerchantEntityFactory.build,
      ]

      allow(repository).to receive(:all).and_return(merchants)

      result = use_case.retrieve_all

      expect(result).to eq(merchants)
    end
  end
end
