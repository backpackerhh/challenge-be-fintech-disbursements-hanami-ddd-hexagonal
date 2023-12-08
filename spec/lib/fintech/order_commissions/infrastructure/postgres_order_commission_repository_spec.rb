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
      order_commission_order_a = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: order_a.id.value,
        order_amount: order_a.amount.value
      )
      order_b = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
      order_commission_order_b = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: order_b.id.value,
        order_amount: order_b.amount.value
      )

      order_commissions = repository.all

      expect(order_commissions).to contain_exactly(order_commission_order_a, order_commission_order_b)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "does not create a new order commission" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        initial_order_commissions = repository.all

        repository.create(order_commission.to_primitives)

        new_order_commissions = repository.all

        expect(new_order_commissions.map(&:id)).to eq(initial_order_commissions.map(&:id))
      end

      it "logs any error from the database" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
        order_commission = Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order.id.value,
          order_amount: order.amount.value
        )

        expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

        repository.create(order_commission.to_primitives)
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

        initial_order_commissions = repository.all

        repository.create(order_commission.to_primitives)

        new_order_commissions = repository.all

        expect(new_order_commissions.map(&:id)).not_to eq(initial_order_commissions.map(&:id))
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
end
