# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Disbursements::Infrastructure::PostgresDisbursementRepository, type: %i[repository database] do
  describe "#all" do
    it "returns empty array without any disbursements" do
      repository = described_class.new

      disbursements = repository.all

      expect(disbursements).to eq([])
    end

    it "returns all disbursements" do
      repository = described_class.new
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      disbursement_a = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(merchant_id: merchant.id.value)
      disbursement_b = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(merchant_id: merchant.id.value)

      disbursements = repository.all

      expect(disbursements).to contain_exactly(disbursement_a, disbursement_b)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "does not create a new disbursement" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(merchant_id: merchant.id.value)

        disbursements = repository.all

        expect(disbursements.size).to eq(1)

        repository.create(disbursement.to_primitives)

        disbursements = repository.all

        expect(disbursements.size).to eq(1)
      end

      it "logs any error from the database" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(merchant_id: merchant.id.value)

        expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

        repository.create(disbursement.to_primitives)
      end
    end

    context "without errors" do
      it "creates a new disbursement" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.build(merchant_id: merchant.id.value)

        disbursements = repository.all

        expect(disbursements.size).to eq(0)

        repository.create(disbursement.to_primitives)

        disbursements = repository.all

        expect(disbursements.size).to eq(1)
      end
    end
  end
end
