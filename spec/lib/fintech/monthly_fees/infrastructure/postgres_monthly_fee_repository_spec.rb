# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::MonthlyFees::Infrastructure::PostgresMonthlyFeeRepository, type: %i[repository database] do
  describe "#all" do
    it "returns empty array without any monthly fees" do
      repository = described_class.new

      monthly_fees = repository.all

      expect(monthly_fees).to eq([])
    end

    it "returns all monthly_fees" do
      repository = described_class.new
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      monthly_fee_a = Fintech::MonthlyFees::Domain::MonthlyFeeEntityFactory.create(merchant_id: merchant.id.value)
      monthly_fee_b = Fintech::MonthlyFees::Domain::MonthlyFeeEntityFactory.create(merchant_id: merchant.id.value)

      monthly_fees = repository.all

      expect(monthly_fees).to contain_exactly(monthly_fee_a, monthly_fee_b)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        monthly_fee = Fintech::MonthlyFees::Domain::MonthlyFeeEntityFactory.create(merchant_id: merchant.id.value)

        expect do
          repository.create(monthly_fee.to_primitives)
        end.to raise_error(Fintech::Shared::Infrastructure::DatabaseError)
      end
    end

    context "without errors" do
      it "creates a new monthly fee" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        monthly_fee = Fintech::MonthlyFees::Domain::MonthlyFeeEntityFactory.build(merchant_id: merchant.id.value)

        monthly_fees = repository.all

        expect(monthly_fees.size).to eq(0)

        repository.create(monthly_fee.to_primitives)

        monthly_fees = repository.all

        expect(monthly_fees.size).to eq(1)
      end
    end
  end
end
