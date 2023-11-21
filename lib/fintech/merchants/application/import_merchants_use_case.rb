# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class ImportMerchantsUseCase < Shared::Application::UseCase
        repository Domain::MerchantRepository::Interface, dependency_key: "merchants.repository"
      end
    end
  end
end
