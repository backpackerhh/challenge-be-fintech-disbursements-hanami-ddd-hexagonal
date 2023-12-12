# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class UpdateDisbursedOrdersUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface

        def update_disbursed(_order_ids, _disbursement_id)
          # TODO
        end
      end
    end
  end
end
