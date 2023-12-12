# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class GroupDisbursableOrdersJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        include Deps[create_disbursement_job: "disbursements.create.job"]

        def perform(grouping_type, merchant_id)
          grouped_orders = Application::GroupDisbursableOrdersUseCase.new.retrieve_grouped(grouping_type, merchant_id)

          grouped_orders.each do |disbursement_attributes|
            create_disbursement_job.perform_async(disbursement_attributes.merge(merchant_id:))
          end
        end
      end
    end
  end
end
