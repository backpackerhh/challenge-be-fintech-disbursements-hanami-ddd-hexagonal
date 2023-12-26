# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class FindOrderService < Shared::Domain::Service
        attribute :repository, Domain::OrderRepository::Interface

        include Deps["orders.repository"]

        def find(id)
          repository.find_by_id(id)
        end
      end
    end
  end
end
