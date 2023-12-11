# frozen_string_literal: true

Hanami.app.register_provider :orders, namespace: true do
  prepare do
    register "repository", Fintech::Orders::Infrastructure::PostgresOrderRepository.new
  end

  start do
    register "find.use_case", Fintech::Orders::Application::FindOrderUseCase.new
    register "group_disbursable.job", Fintech::Orders::Infrastructure::GroupDisbursableOrdersJob
  end
end
