# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class FindMerchantUseCase < Shared::Application::UseCase
        repository "merchants.repository", Domain::MerchantRepository::Interface

        def find(id)
          repository.find_by_id(id)
        end
      end
    end
  end
end
