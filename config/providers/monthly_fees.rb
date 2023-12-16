# frozen_string_literal: true

Hanami.app.register_provider :monthly_fees, namespace: true do
  start do
    register "repository", Fintech::MonthlyFees::Infrastructure::PostgresMonthlyFeeRepository.new
  end
end
