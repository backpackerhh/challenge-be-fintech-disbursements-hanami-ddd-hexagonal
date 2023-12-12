# frozen_string_literal: true

Hanami.app.register_provider :disbursements, namespace: true do
  prepare do
    register "repository", Fintech::Disbursements::Infrastructure::PostgresDisbursementRepository.new
  end

  start do
    register "create.job", Fintech::Disbursements::Infrastructure::CreateDisbursementJob
  end
end
