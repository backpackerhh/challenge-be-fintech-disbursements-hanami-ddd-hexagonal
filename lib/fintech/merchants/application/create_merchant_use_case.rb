# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class CreateMerchantUseCase < Shared::Application::UseCase
        repository Domain::MerchantRepository::Interface, dependency_key: "merchants.repository"

        def create(attributes)
          merchant = Domain::MerchantEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(merchant.to_primitives)
        end
      end
    end
  end
end
