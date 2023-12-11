# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class FindDisbursableMerchantsUseCase < Shared::Application::UseCase
        repository "merchants.repository", Domain::MerchantRepository::Interface
        logger

        def retrieve_grouped_ids
          grouped_disbursable_merchant_ids = repository.grouped_disbursable_ids

          logger.info("Grouped disbursable merchant IDs successfully retrieved")

          grouped_disbursable_merchant_ids
        end
      end
    end
  end
end
