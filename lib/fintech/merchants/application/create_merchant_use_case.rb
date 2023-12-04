# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class CreateMerchantUseCase < Shared::Application::UseCase
        repository "merchants.repository", Domain::MerchantRepository::Interface
        logger
        event_bus

        def create(attributes)
          merchant = Domain::MerchantEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(merchant.to_primitives)

          logger.info("Merchant #{merchant.id.value} successfully created")

          event_bus.publish(Domain::MerchantCreatedEvent.from(merchant))
        end
      end
    end
  end
end
