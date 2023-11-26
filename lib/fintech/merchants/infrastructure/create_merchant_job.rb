# frozen_string_literal: true

module Fintech
  module Merchants
    module Infrastructure
      class CreateMerchantJob < Shared::Infrastructure::Job
        sidekiq_options queue: "import_data", unique: true, retry_for: 3600 # 1 hour

        def perform(merchant_attributes)
          Application::CreateMerchantUseCase.new.create(merchant_attributes)

          logger.info("Merchant #{merchant_attributes['id']} successfully created")
        end
      end
    end
  end
end
