# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Infrastructure::PostgresOrderRepository, type: %i[repository database] do
  describe "#all" do
    it "returns empty array without any orders" do
      repository = described_class.new

      orders = repository.all

      expect(orders).to eq([])
    end

    it "returns all orders" do
      repository = described_class.new
      merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
      order_a = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)
      order_b = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)

      orders = repository.all

      expect(orders).to contain_exactly(order_a, order_b)
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "does not create a new order" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)

        initial_orders = repository.all

        repository.create(order.to_primitives)

        new_orders = repository.all

        expect(new_orders.map(&:id)).to eq(initial_orders.map(&:id))
      end

      it "logs any error from the database" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)

        expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

        repository.create(order.to_primitives)
      end
    end

    context "without errors" do
      it "creates a new order" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.build(merchant_id: merchant.id.value)

        initial_orders = repository.all

        repository.create(order.to_primitives)

        new_orders = repository.all

        expect(new_orders.map(&:id)).not_to eq(initial_orders.map(&:id))
      end
    end
  end

  describe "#find_by_id(id)" do
    it "logs any error from the database" do
      repository = described_class.new

      expect(repository.logger).to receive(:error).with(kind_of(Sequel::DatabaseError))

      repository.find_by_id("uuid")
    end

    context "when given order does not exist" do

      it "raises an exception" do
        repository = described_class.new

        expect do
          repository.find_by_id(SecureRandom.uuid)
        end.to raise_error(Fintech::Orders::Domain::OrderNotFoundError)
      end
    end

    context "when given order exists" do
      it "returns an instance of the entity" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create
        order = Fintech::Orders::Domain::OrderEntityFactory.create(merchant_id: merchant.id.value)

        expect(repository.find_by_id(order.id.value)).to eq(order)
      end
    end
  end
end
