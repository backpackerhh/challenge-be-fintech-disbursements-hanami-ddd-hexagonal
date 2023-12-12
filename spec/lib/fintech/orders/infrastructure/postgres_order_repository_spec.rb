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

  describe "#group(grouping_type, merchant_id)" do
    context "when given grouping type is not supported" do
      it "raises an exception" do
        repository = described_class.new
        merchant_id = SecureRandom.uuid

        expect do
          repository.group("unknown", merchant_id)
        end.to raise_error(Fintech::Orders::Domain::UnsupportedGroupingTypeError)
      end
    end

    context "when there are no orders for given merchant" do
      it "returns empty array" do
        repository = described_class.new
        merchant_id = SecureRandom.uuid

        results = repository.group("daily", merchant_id)

        expect(results).to eq([])
      end
    end

    context "when there are orders for given merchant", freeze_time: "2023-04-14 07:00 UTC" do
      it "returns orders grouped by day" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create(
          :daily_disbursement,
          live_on: Date.parse("2022-01-06")
        )
        order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("349.99"),
          created_at: Time.parse("2022-11-15 08:59:31")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_1.id.value,
          order_amount: order_1.amount.value,
          created_at: Time.parse("2022-11-15 08:59:52")
        )
        order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("140.25"),
          created_at: Time.parse("2022-11-15 08:59:45")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_2.id.value,
          order_amount: order_2.amount.value,
          created_at: Time.parse("2022-11-15 09:00:14")
        )
        disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
          merchant_id: merchant.id.value,
          amount: BigDecimal("100.0"),
          commissions_amount: BigDecimal("1.0"),
          order_ids: []
        )
        order_3 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: disbursement.id.value,
          amount: BigDecimal("26.95"),
          created_at: Time.parse("2023-01-12 07:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_3.id.value,
          order_amount: order_3.amount.value,
          created_at: Time.parse("2023-01-12 07:55:13")
        )
        order_4 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("10.99"),
          created_at: Time.parse("2023-04-13 23:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_4.id.value,
          order_amount: order_4.amount.value,
          created_at: Time.parse("2023-04-13 23:55:13")
        )
        order_5 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("9.99"),
          created_at: Time.parse("2023-04-14 06:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_5.id.value,
          order_amount: order_5.amount.value,
          created_at: Time.parse("2023-04-14 06:55:13")
        )

        results = repository.group("daily", merchant.id.value)

        expect(results).to eq(
          [
            {
              amount: BigDecimal("490.24"),
              commissions_amount: BigDecimal("4.32"),
              order_ids: [order_1.id.value, order_2.id.value],
              start_date: Date.parse("2022-11-15"),
              end_date: Date.parse("2022-11-15")
            },
            {
              amount: BigDecimal("10.99"),
              commissions_amount: BigDecimal("0.11"),
              order_ids: [order_4.id.value],
              start_date: Date.parse("2023-04-13"),
              end_date: Date.parse("2023-04-13")
            },
          ]
        )
      end

      it "returns orders grouped by week" do
        repository = described_class.new
        merchant = Fintech::Merchants::Domain::MerchantEntityFactory.create(
          :weekly_disbursement,
          live_on: Date.parse("2022-01-06")
        )
        order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("349.99"),
          created_at: Time.parse("2022-11-14 08:59:31")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_1.id.value,
          order_amount: order_1.amount.value,
          created_at: Time.parse("2022-11-14 08:59:52")
        )
        order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("140.25"),
          created_at: Time.parse("2022-11-15 08:59:45")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_2.id.value,
          order_amount: order_2.amount.value,
          created_at: Time.parse("2022-11-15 09:00:14")
        )
        order_3 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("1399.95"),
          created_at: Time.parse("2023-01-05 18:59:45")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_3.id.value,
          order_amount: order_3.amount.value,
          created_at: Time.parse("2023-01-05 19:00:14")
        )
        disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
          merchant_id: merchant.id.value,
          amount: BigDecimal("100.0"),
          commissions_amount: BigDecimal("1.0"),
          order_ids: []
        )
        order_4 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: disbursement.id.value,
          amount: BigDecimal("26.95"),
          created_at: Time.parse("2023-01-06 07:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_4.id.value,
          order_amount: order_4.amount.value,
          created_at: Time.parse("2023-01-06 07:55:13")
        )
        order_5 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("10.99"),
          created_at: Time.parse("2023-04-13 23:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_5.id.value,
          order_amount: order_5.amount.value,
          created_at: Time.parse("2023-04-13 23:55:13")
        )
        order_6 = Fintech::Orders::Domain::OrderEntityFactory.create(
          merchant_id: merchant.id.value,
          disbursement_id: nil,
          amount: BigDecimal("9.99"),
          created_at: Time.parse("2023-04-14 06:54:03")
        )
        Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
          order_id: order_6.id.value,
          order_amount: order_6.amount.value,
          created_at: Time.parse("2023-04-14 06:55:13")
        )

        results = repository.group("weekly", merchant.id.value)

        expect(results).to eq(
          [
            {
              amount: BigDecimal("490.24"),
              commissions_amount: BigDecimal("4.32"),
              order_ids: [order_1.id.value, order_2.id.value],
              start_date: Date.parse("2022-11-14"),
              end_date: Date.parse("2022-11-20")
            },
            {
              amount: BigDecimal("1399.95"),
              commissions_amount: BigDecimal("11.90"),
              order_ids: [order_3.id.value],
              start_date: Date.parse("2023-01-02"),
              end_date: Date.parse("2023-01-08")
            },
          ]
        )
      end
    end
  end
end
