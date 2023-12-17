# frozen_string_literal: true

Hanami.app.register_provider :monthly_fees, namespace: true do
  prepare do
    register "repository", Fintech::MonthlyFees::Infrastructure::PostgresMonthlyFeeRepository.new
  end

  start do
    register "create.job", Fintech::MonthlyFees::Infrastructure::CreateMonthlyFeeJob
  end
end
