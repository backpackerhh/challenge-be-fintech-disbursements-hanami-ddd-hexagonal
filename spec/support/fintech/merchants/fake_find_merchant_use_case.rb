# frozen_string_literal: true

module Fintech
  module Merchants
    module Application
      class FakeFindMerchantUseCase < Shared::Application::UseCase
        repository "merchants.repository", Domain::MerchantRepository::Interface

        def find(_id); end
      end
    end
  end
end
