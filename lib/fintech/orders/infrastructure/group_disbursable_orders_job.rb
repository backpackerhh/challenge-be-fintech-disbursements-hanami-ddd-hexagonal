# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class GroupDisbursableOrdersJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        include Deps[group_disbursable_orders_service: "orders.group_disbursable.service",
                     create_disbursement_job: "disbursements.create.job"]

        DEFAULT_INTERVAL = 5

        def perform(grouping_type, merchant_id)
          grouped_orders = group_disbursable_orders_service.retrieve_grouped(grouping_type, merchant_id)

          grouped_orders.each_with_index do |disbursement_attributes, idx|
            interval = idx * DEFAULT_INTERVAL
            attributes = JSON.parse(disbursement_attributes.merge(merchant_id:).to_json)

            create_disbursement_job.perform_in(interval, attributes)
          end
        end
      end
    end
  end
end
