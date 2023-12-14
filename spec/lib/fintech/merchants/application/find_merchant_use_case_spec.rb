# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Application::FindMerchantUseCase, type: :use_case do
  describe "#find(id)" do
    let(:repository) { Fintech::Merchants::Infrastructure::InMemoryMerchantRepository.new }

    context "with an existing merchant" do
      it "returns it" do
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.build
        use_case = described_class.new(repository:)

        allow(repository).to receive(:find_by_id).with(merchant.id.value).and_return(merchant)

        found_merchant = use_case.find(merchant.id.value)

        expect(found_merchant).to eq(merchant)
      end
    end

    context "with a non-existing merchant" do
      it "raises an exception" do
        use_case = described_class.new(repository:)

        allow(repository).to receive(:find_by_id).with("merchant_id")
                                                 .and_raise(Fintech::Merchants::Domain::MerchantNotFoundError)

        expect do
          use_case.find("merchant_id")
        end.to raise_error(Fintech::Merchants::Domain::MerchantNotFoundError)
      end
    end
  end
end
