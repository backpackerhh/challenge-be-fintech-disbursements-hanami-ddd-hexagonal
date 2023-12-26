# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class GroupDisbursableOrdersService < Shared::Domain::Service
        attribute :repository, Domain::OrderRepository::Interface

        include Deps["orders.repository"]

        def retrieve_grouped(grouping_type, merchant_id)
          repository.group(grouping_type, merchant_id)
        end
      end
    end
  end
end
