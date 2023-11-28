# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class ListMerchantsUseCase < Shared::Application::UseCase
        repository "merchants.repository", type: Domain::MerchantRepository::Interface
        logger

        def all
          merchants = repository.all

          logger.info("Merchant successfully retrieved")

          merchants
        end
      end
    end
  end
end
