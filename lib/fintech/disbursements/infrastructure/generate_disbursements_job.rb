# frozen_string_literal: true

module Fintech
  module Disbursements
    module Infrastructure
      class GenerateDisbursementsJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        include Deps[find_disbursable_merchants_service: "merchants.find_disbursable.service",
                     group_disbursable_orders_job: "orders.group_disbursable.job"]

        def perform
          grouped_disbursable_merchant_ids = find_disbursable_merchants_service.retrieve_grouped_ids

          grouped_disbursable_merchant_ids.each do |disbursement_frequency, merchant_ids|
            merchant_ids.each do |merchant_id|
              group_disbursable_orders_job.perform_async(disbursement_frequency.downcase, merchant_id)
            end
          end
        end
      end
    end
  end
end
