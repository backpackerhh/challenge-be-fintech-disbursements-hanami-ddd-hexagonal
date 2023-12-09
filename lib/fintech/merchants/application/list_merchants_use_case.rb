# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class ListMerchantsUseCase < Shared::Application::UseCase
        repository "merchants.repository", Domain::MerchantRepository::Interface
        logger

        def retrieve_all
          merchants = repository.all

          logger.info("Merchants successfully retrieved")

          merchants
        end
      end
    end
  end
end
