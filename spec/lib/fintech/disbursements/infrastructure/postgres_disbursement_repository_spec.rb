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

  describe "#first_in_month_for_merchant?(merchant_id:, date:)" do
    it "logs any error from the database" do
      repository = described_class.new

      expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

      repository.first_in_month_for_merchant?(merchant_id: "invalid uuid", date: Date.today)
    end

    context "when there is more than one result for given merchant" do
      it "returns false", freeze_time: Time.parse("2023-04-01 07:00 UTC") do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
          merchant_id: merchant.id.value,
          start_date: Date.parse("2023-02-01"),
          end_date: Date.parse("2023-02-01"),
          created_at: Time.parse("2023-04-01 07:00 UTC")
        )
        Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
          merchant_id: merchant.id.value,
          start_date: Date.parse("2023-02-08"),
          end_date: Date.parse("2023-02-08"),
          created_at: Time.parse("2023-04-01 07:00 UTC")
        )

        result = repository.first_in_month_for_merchant?(merchant_id: merchant.id.value, date: Date.parse("2023-02-11"))

        expect(result).to be false
      end
    end

    context "when there is exactly one result for given merchant" do
      it "returns true", freeze_time: Time.parse("2023-04-01 07:00 UTC") do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
          merchant_id: merchant.id.value,
          start_date: Date.parse("2023-02-01"),
          end_date: Date.parse("2023-02-01"),
          created_at: Time.parse("2023-04-01 07:00 UTC")
        )

        result = repository.first_in_month_for_merchant?(merchant_id: merchant.id.value, date: Date.parse("2023-02-11"))

        expect(result).to be true
      end
    end
  end
end
