# frozen_string_literal: true

Hanami.app.register_provider :orders, namespace: true do
  start do
    register "repository", Fintech::Orders::Infrastructure::PostgresOrderRepository.new
  end
end
