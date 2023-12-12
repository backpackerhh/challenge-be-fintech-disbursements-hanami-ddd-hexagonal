# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersUpdatedEvent < Shared::Domain::Event
        def self.from(_order_ids, _disbursement_id)
          # TODO
        end
      end
    end
  end
end
