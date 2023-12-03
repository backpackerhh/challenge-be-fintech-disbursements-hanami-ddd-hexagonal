# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantCreatedEvent < Shared::Domain::Event
        def self.from(entity)
          new(
            aggregate_id: entity.id.value,
            aggregate_attributes: {
              email: entity.email.value,
              reference: entity.reference.value
            },
            occurred_at: entity.created_at.value
          )
        end
      end
    end
  end
end
