# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantCreatedEvent < Shared::Domain::Event
        def self.from(merchant)
          from_primitives(
            aggregate_id: merchant.id.value,
            aggregate_attributes: {
              email: merchant.email.value,
              reference: merchant.reference.value
            },
            occurred_at: merchant.created_at.value
          )
        end
      end
    end
  end
end
