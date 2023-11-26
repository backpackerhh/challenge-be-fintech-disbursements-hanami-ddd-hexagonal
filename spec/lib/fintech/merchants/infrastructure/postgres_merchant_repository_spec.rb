# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Infrastructure::PostgresMerchantRepository, type: %i[repository database] do
  describe "#all" do
    it "returns empty array without any merchants" do
      repository = described_class.new

      merchants = repository.all

      expect(merchants).to eq([])
    end

    it "returns all merchants" do
      repository = described_class.new
      merchant_a = Fintech::Merchants::Domain::MerchantEntityFactory.create(reference: "A")
      merchant_b = Fintech::Merchants::Domain::MerchantEntityFactory.create(reference: "B")

      merchants = repository.all

      expect(merchants).to contain_exactly(merchant_a, merchant_b)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "does not create a new merchant" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create

        initial_merchants = repository.all

        repository.create(merchant.to_primitives)

        new_merchants = repository.all

        expect(new_merchants.map(&:id)).to eq(initial_merchants.map(&:id))
      end

      it "logs any error from the database" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create

        expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

        repository.create(merchant.to_primitives)
      end
    end

    context "without errors" do
      it "creates a new merchant" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.build

        initial_merchants = repository.all

        repository.create(merchant.to_primitives)

        new_merchants = repository.all

        expect(new_merchants.map(&:id)).not_to eq(initial_merchants.map(&:id))
      end
    end
  end
end
