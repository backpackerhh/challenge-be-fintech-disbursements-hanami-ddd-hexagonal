# frozen_string_literal: true

Hanami.app.register_provider :merchants, namespace: true do
  prepare do
    register "repository", Fintech::Merchants::Infrastructure::PostgresMerchantRepository.new
  end

  start do
    register "list.service", Fintech::Merchants::Domain::ListMerchantsService.new
    register "find.service", Fintech::Merchants::Domain::FindMerchantService.new
    register "find_disbursable.service", Fintech::Merchants::Domain::FindDisbursableMerchantsService.new
  end
end
