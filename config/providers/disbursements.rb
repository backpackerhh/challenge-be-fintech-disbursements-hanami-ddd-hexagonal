# frozen_string_literal: true

Hanami.app.register_provider :disbursements, namespace: true do
  start do
    register "repository", Fintech::Disbursements::Infrastructure::PostgresDisbursementRepository.new
  end
end
