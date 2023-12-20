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

  describe "#grouped_disbursable_ids" do
    it "returns all disbursable merchant IDs grouped by disbursement frequency", freeze_time: "2023-04-14 07:00:00" do
      repository = described_class.new
      merchant_a = Fintech::Merchants::Domain::MerchantEntityFactory.create(:daily_disbursement)
      merchant_b = Fintech::Merchants::Domain::MerchantEntityFactory.create(:daily_disbursement)
      merchant_c = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :weekly_disbursement,
        live_on: Date.parse("2023-04-06")
      )
      merchant_d = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :weekly_disbursement,
        live_on: Date.parse("2023-04-07")
      )

      grouped_disbursable_merchant_ids = repository.grouped_disbursable_ids

      expect(grouped_disbursable_merchant_ids).to eq(
        {
          Fintech::Merchants::Domain::MerchantDisbursementFrequencyFactory.daily => [
            merchant_a.id.value,
            merchant_b.id.value,
          ],
          Fintech::Merchants::Domain::MerchantDisbursementFrequencyFactory.weekly => [
            merchant_d.id.value,
          ]
        }
      )
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create

        expect do
          repository.create(merchant.to_primitives)
        end.to raise_error(Fintech::Shared::Infrastructure::DatabaseError)
      end
    end

    context "without errors" do
      it "creates a new merchant" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.build

        merchants = repository.all

        expect(merchants.size).to eq(0)

        repository.create(merchant.to_primitives)

        merchants = repository.all

        expect(merchants.size).to eq(1)
      end
    end
  end
end
