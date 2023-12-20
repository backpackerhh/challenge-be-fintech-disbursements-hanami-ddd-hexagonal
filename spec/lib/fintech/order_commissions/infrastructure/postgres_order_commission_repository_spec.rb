# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::OrderCommissions::Infrastructure::PostgresOrderCommissionRepository,
               type: %i[repository database] do
  describe "#all" do
    it "returns empty array without any order commissions" do
      repository = described_class.new

      order_commissions = repository.all

      expect(order_commissions).to eq([])
    end

    it "returns all order commissions" do
      repository = described_class.new
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      order_a = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
      order_a_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: order_a.id.value,
        order_amount: order_a.amount.value
      )
      order_b = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
      order_b_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: order_b.id.value,
        order_amount: order_b.amount.value
      )

      order_commissions = repository.all

      expect(order_commissions).to contain_exactly(order_a_commission, order_b_commission)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        expect do
          repository.create(order_commission.to_primitives)
        end.to raise_error(Fintech::Shared::Infrastructure::DatabaseError)
      end
    end

    context "without errors" do
      it "creates a new order commission" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.build(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        order_commissions = repository.all

        expect(order_commissions.size).to eq(0)

        repository.create(order_commission.to_primitives)

        order_commissions = repository.all

        expect(order_commissions.size).to eq(1)
      end
    end
  end

  describe "#exists?(attributes)" do
    context "when another record exists with given attributes" do
      it "returns true checking by ID" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        result = repository.exists?(id: order_commission.id.value)

        expect(result).to be true
      end

      it "returns true checking by order ID" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        result = repository.exists?(order_id: order_commission.order_id.value)

        expect(result).to be true
      end
    end

    context "when another record does not exist with given attributes" do
      it "returns false" do
        repository = described_class.new

        result = repository.exists?(id: SecureRandom.uuid)

        expect(result).to be false
      end
    end
  end

  describe "#monthly_amount(merchant_id:, date:)" do
    it "returns 0.0 for a merchant without any orders" do
      repository = described_class.new

      result = repository.monthly_amount(merchant_id: SecureRandom.uuid, date: Date.today)

      expect(result).to eq(0.0)
    end

    it "returns the commissions amount in the month for a merchant" do
      repository = described_class.new
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      march_order = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        created_at: Time.parse("2023-03-31")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: march_order.id.value,
        order_amount: march_order.amount.value,
        amount: BigDecimal("0.45")
      )
      april_order_a = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        created_at: Time.parse("2023-04-01")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: april_order_a.id.value,
        order_amount: april_order_a.amount.value,
        amount: BigDecimal("1.35")
      )
      april_order_b = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        created_at: Time.parse("2023-04-30")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: april_order_b.id.value,
        order_amount: april_order_b.amount.value,
        amount: BigDecimal("2.31")
      )
      may_order = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant.id.value,
        created_at: Time.parse("2023-05-01")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: may_order.id.value,
        order_amount: may_order.amount.value,
        amount: BigDecimal("0.08")
      )

      result = repository.monthly_amount(merchant_id: merchant.id.value, date: Date.parse("2023-04-01"))

      expect(result).to eq(3.66)
    end
  end
end
