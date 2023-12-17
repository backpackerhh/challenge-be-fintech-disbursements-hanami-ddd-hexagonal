# frozen_string_literal: true

module Fintech
  module Disbursements
    module Infrastructure
      class CreateDisbursementJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        include Deps[create_monthly_fee_job: "monthly_fees.create.job"]

        def perform(disbursement_attributes)
          Application::CreateDisbursementUseCase.new.create(
            disbursement_attributes,
            callback: lambda do
              create_monthly_fee_job.perform_async(
                disbursement_attributes["merchant_id"],
                disbursement_attributes["start_date"]
              )
            end
          )

          logger.info("Disbursement for merchant #{disbursement_attributes['merchant_id']} successfully created")
        end
      end
    end
  end
end
