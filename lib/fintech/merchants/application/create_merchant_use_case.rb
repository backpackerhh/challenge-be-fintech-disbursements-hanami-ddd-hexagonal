# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class CreateMerchantUseCase < Shared::Application::UseCase
        repository "merchants.repository", type: Domain::MerchantRepository::Interface
        logger

        def create(attributes)
          merchant = Domain::MerchantEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(merchant.to_primitives)

          logger.info("Merchant successfully created!")
        end
      end
    end
  end
end
