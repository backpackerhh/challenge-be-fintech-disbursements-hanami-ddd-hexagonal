# frozen_string_literal: true

Hanami.app.register_provider :order_commissions, namespace: true do
  prepare do
    register "repository", Fintech::OrderCommissions::Infrastructure::PostgresOrderCommissionRepository.new
  end

  start do
    register "find_monthly.use_case", Fintech::OrderCommissions::Application::FindMonthlyOrderCommissionsUseCase.new
  end
end
