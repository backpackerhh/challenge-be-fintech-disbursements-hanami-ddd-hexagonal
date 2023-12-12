# frozen_string_literal: true

module Fintech
  module Disbursements
    module Infrastructure
      class CreateDisbursementJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        def perform(disbursement_attributes)
          Application::CreateDisbursementUseCase.new.create(disbursement_attributes)

          logger.info("Disbursement for merchant #{disbursement_attributes['merchant_id']} successfully created")
        end
      end
    end
  end
end
