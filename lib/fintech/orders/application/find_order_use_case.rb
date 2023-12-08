# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class FindOrderUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface

        def find(id)
          repository.find_by_id(id)
        end
      end
    end
  end
end
