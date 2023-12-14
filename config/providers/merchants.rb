# frozen_string_literal: true

Hanami.app.register_provider :merchants, namespace: true do
  prepare do
    register "repository", Fintech::Merchants::Infrastructure::PostgresMerchantRepository.new
  end

  start do
    register "list.use_case", Fintech::Merchants::Application::ListMerchantsUseCase.new
    register "find.use_case", Fintech::Merchants::Application::FindMerchantUseCase.new
  end
end
