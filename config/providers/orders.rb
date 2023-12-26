# frozen_string_literal: true

Hanami.app.register_provider :orders, namespace: true do
  prepare do
    register "repository", Fintech::Orders::Infrastructure::PostgresOrderRepository.new
  end

  start do
    register "group_disbursable.job", Fintech::Orders::Infrastructure::GroupDisbursableOrdersJob
    register "group_disbursable.service", Fintech::Orders::Domain::GroupDisbursableOrdersService.new
    register "find.service", Fintech::Orders::Domain::FindOrderService.new
  end
end
