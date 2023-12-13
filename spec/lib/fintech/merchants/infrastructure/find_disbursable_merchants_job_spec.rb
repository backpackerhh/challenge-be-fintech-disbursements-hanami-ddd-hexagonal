# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Infrastructure::FindDisbursableMerchantsJob, type: %i[job database] do
  it "has expected configuration" do
    expect(described_class.sidekiq_options.transform_keys(&:to_sym)).to eq(
      {
        queue: "disbursements",
        unique: true,
        retry: true,
        retry_for: 3600
      }
    )
  end

  describe "#perform" do
    it "starts process to generate disbursements",
       :sidekiq_inline, fake_event_bus: "domain_events.bus", freeze_time: Time.parse("2023-04-14 07:00 UTC") do
      merchant_a = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :weekly_disbursement,
        live_on: Date.parse("2022-01-06")
      )
      merchant_b = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :daily_disbursement,
        live_on: Date.parse("2022-05-28")
      )
      merchant_c = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :daily_disbursement,
        live_on: Date.parse("2022-11-14")
      )
      merchant_d = Fintech::Merchants::Domain::MerchantEntityFactory.create(
        :weekly_disbursement,
        live_on: Date.parse("2023-02-10")
      )

      merchant_a_order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_a.id.value,
        amount: BigDecimal("158.97"),
        created_at: Time.parse("2023-04-08 14:01:31")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_a_order_1.id.value,
        order_amount: merchant_a_order_1.amount.value,
        created_at: Time.parse("2023-04-08 14:01:52")
      )
      merchant_a_order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_a.id.value,
        amount: BigDecimal("26.99"),
        created_at: Time.parse("2023-04-12 07:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_a_order_2.id.value,
        order_amount: merchant_a_order_2.amount.value,
        created_at: Time.parse("2023-04-12 07:55:13")
      )

      merchant_b_order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_b.id.value,
        amount: BigDecimal("302.99"),
        created_at: Time.parse("2022-05-29 08:59:31")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_b_order_1.id.value,
        order_amount: merchant_b_order_1.amount.value,
        created_at: Time.parse("2022-05-29 08:59:52")
      )
      merchant_b_order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_b.id.value,
        amount: BigDecimal("14.25"),
        created_at: Time.parse("2022-05-29 08:59:45")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_b_order_2.id.value,
        order_amount: merchant_b_order_2.amount.value,
        created_at: Time.parse("2022-05-29 09:00:14")
      )
      merchant_b_order_3 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_b.id.value,
        amount: BigDecimal("261.13"),
        created_at: Time.parse("2023-01-12 07:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_b_order_3.id.value,
        order_amount: merchant_b_order_3.amount.value,
        created_at: Time.parse("2023-01-12 07:55:13")
      )
      merchant_b_order_4 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_b.id.value,
        amount: BigDecimal("1099.99"),
        created_at: Time.parse("2023-04-14 06:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_b_order_4.id.value,
        order_amount: merchant_b_order_4.amount.value,
        created_at: Time.parse("2023-04-14 06:55:13")
      )

      merchant_c_order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_c.id.value,
        amount: BigDecimal("349.99"),
        created_at: Time.parse("2022-11-15 08:59:31")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_c_order_1.id.value,
        order_amount: merchant_c_order_1.amount.value,
        created_at: Time.parse("2022-11-15 08:59:52")
      )
      merchant_c_order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_c.id.value,
        amount: BigDecimal("140.25"),
        created_at: Time.parse("2022-11-15 08:59:45")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_c_order_2.id.value,
        order_amount: merchant_c_order_2.amount.value,
        created_at: Time.parse("2022-11-15 09:00:14")
      )
      merchant_c_disbursement = Fintech::Disbursements::Domain::DisbursementEntityFactory.create(
        merchant_id: merchant_c.id.value,
        amount: BigDecimal("100.0"),
        commissions_amount: BigDecimal("1.0"),
        order_ids: []
      )
      merchant_c_order_3 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_c.id.value,
        disbursement_id: merchant_c_disbursement.id.value,
        amount: BigDecimal("26.95"),
        created_at: Time.parse("2023-01-12 07:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_c_order_3.id.value,
        order_amount: merchant_c_order_3.amount.value,
        created_at: Time.parse("2023-01-12 07:55:13")
      )
      merchant_c_order_4 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_c.id.value,
        amount: BigDecimal("10.99"),
        created_at: Time.parse("2023-04-13 23:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_c_order_4.id.value,
        order_amount: merchant_c_order_4.amount.value,
        created_at: Time.parse("2023-04-13 23:55:13")
      )
      merchant_c_order_5 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_c.id.value,
        amount: BigDecimal("9.99"),
        created_at: Time.parse("2023-04-13 23:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_c_order_5.id.value,
        order_amount: merchant_c_order_5.amount.value,
        created_at: Time.parse("2023-04-13 23:55:13")
      )

      merchant_d_order_1 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_d.id.value,
        amount: BigDecimal("1510.99"),
        created_at: Time.parse("2023-02-11 08:59:31")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_d_order_1.id.value,
        order_amount: merchant_d_order_1.amount.value,
        created_at: Time.parse("2023-02-11 08:59:52")
      )
      merchant_d_order_2 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_d.id.value,
        amount: BigDecimal("23.01"),
        created_at: Time.parse("2023-02-11 08:59:45")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_d_order_2.id.value,
        order_amount: merchant_d_order_2.amount.value,
        created_at: Time.parse("2023-02-11 09:00:14")
      )
      merchant_d_order_3 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_d.id.value,
        amount: BigDecimal("49.99"),
        created_at: Time.parse("2023-02-12 07:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_d_order_3.id.value,
        order_amount: merchant_d_order_3.amount.value,
        created_at: Time.parse("2023-02-12 07:55:13")
      )
      merchant_d_order_4 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_d.id.value,
        amount: BigDecimal("50.00"),
        created_at: Time.parse("2023-03-01 06:54:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_d_order_4.id.value,
        order_amount: merchant_d_order_4.amount.value,
        created_at: Time.parse("2023-03-01 06:55:13")
      )
      merchant_d_order_5 = Fintech::Orders::Domain::OrderEntityFactory.create(
        merchant_id: merchant_d.id.value,
        amount: BigDecimal("1099.99"),
        created_at: Time.parse("2023-04-11 16:24:03")
      )
      Fintech::OrderCommissions::Domain::OrderCommissionEntityFactory.create(
        order_id: merchant_d_order_5.id.value,
        order_amount: merchant_d_order_5.amount.value,
        created_at: Time.parse("2023-04-11 16:24:13")
      )

      disbursements = Fintech::Container["disbursements.repository"].all

      expect(disbursements.map(&:id)).to eq([merchant_c_disbursement.id])

      described_class.new.perform

      disbursements = Fintech::Container["disbursements.repository"].all.map do |d|
        [d.merchant_id.value, d.amount.value, d.commissions_amount.value, d.order_ids.value]
      end

      expect(disbursements).to contain_exactly(
        [
          merchant_b.id.value,
          BigDecimal("317.24"),
          BigDecimal("2.73"),
          [merchant_b_order_1.id.value, merchant_b_order_2.id.value],
        ],
        [
          merchant_b.id.value,
          BigDecimal("261.13"),
          BigDecimal("2.49"),
          [merchant_b_order_3.id.value],
        ],
        [
          merchant_c.id.value, # the disbursement previously created
          BigDecimal("100.0"),
          BigDecimal("1.0"),
          [],
        ],
        [
          merchant_c.id.value,
          BigDecimal("490.24"),
          BigDecimal("4.32"),
          [merchant_c_order_1.id.value, merchant_c_order_2.id.value],
        ],
        [
          merchant_c.id.value,
          BigDecimal("20.98"),
          BigDecimal("0.21"),
          [merchant_c_order_4.id.value, merchant_c_order_5.id.value],
        ],
        [
          merchant_d.id.value,
          BigDecimal("1583.99"),
          BigDecimal("13.59"),
          [merchant_d_order_1.id.value, merchant_d_order_2.id.value, merchant_d_order_3.id.value],
        ],
        [
          merchant_d.id.value,
          BigDecimal("50.0"),
          BigDecimal("0.48"),
          [merchant_d_order_4.id.value],
        ]
      )
    end
  end
end
