# frozen_string_literal: true

Hanami.app.register_provider :merchants, namespace: true do
  start do
    register "repository", Fintech::Merchants::Infrastructure::PostgresMerchantRepository.new
  end
end
