# frozen_string_literal: true

Hanami.app.register_provider :order_commissions, namespace: true do
  start do
    register "repository", Fintech::OrderCommissions::Infrastructure::PostgresOrderCommissionRepository.new
  end
end
