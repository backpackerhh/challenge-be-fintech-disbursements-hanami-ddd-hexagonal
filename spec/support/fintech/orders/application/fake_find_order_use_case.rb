# frozen_string_literal: true

module Fintech
  module Orders
    module Application
      class FakeFindOrderUseCase < Shared::Application::UseCase
        repository "orders.repository", Domain::OrderRepository::Interface

        def find(_id); end
      end
    end
  end
end
