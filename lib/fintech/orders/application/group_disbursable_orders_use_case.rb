# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class GroupDisbursableOrdersUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface
        logger

        def retrieve_grouped(grouping_type, merchant_id)
          grouped_orders = repository.group(grouping_type, merchant_id)

          logger.info("#{grouping_type.capitalize} orders for merchant #{merchant_id} successfully grouped")

          grouped_orders
        end
      end
    end
  end
end
