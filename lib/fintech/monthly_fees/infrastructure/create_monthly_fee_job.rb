# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Infrastructure
      class CreateMonthlyFeeJob < Shared::Infrastructure::Job
        sidekiq_options queue: "monthly_fees", unique: true, retry_for: 3600 # 1 hour

        include Deps[find_merchant_service: "merchants.find.service",
                     find_monthly_order_commissions_service: "order_commissions.find_monthly.service"]

        def perform(merchant_id, start_date)
          merchant = find_merchant_service.find(merchant_id)
          previous_month_date = Date.parse(start_date).prev_month
          formatted_previous_month = previous_month_date.strftime("%Y-%m")
          commissions_amount = find_monthly_order_commissions_service.sum_monthly_amount(
            merchant_id:,
            date: previous_month_date
          )

          if merchant.monthly_fee_applicable?(commissions_amount:, previous_month_date:)
            Application::CreateMonthlyFeeUseCase.new.create(
              merchant_id:,
              commissions_amount:,
              amount: merchant.minimum_monthly_fee.value - commissions_amount,
              month: formatted_previous_month
            )

            logger.info("Monthly fee for merchant #{merchant_id} successfully created (#{formatted_previous_month})")
          else
            logger.info("No monthly fee created for merchant #{merchant_id} (#{formatted_previous_month})")
          end
        end
      end
    end
  end
end
