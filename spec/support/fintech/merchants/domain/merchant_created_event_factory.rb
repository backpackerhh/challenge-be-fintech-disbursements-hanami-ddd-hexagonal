# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantCreatedEventFactory
        def self.build(attributes = {})
          MerchantCreatedEvent.from_primitives(
            {
              aggregate_id: MerchantIdFactory.build,
              aggregate_attributes: {
                email: MerchantEmailFactory.build,
                reference: MerchantReferenceFactory.build
              },
              occurred_at: MerchantCreatedAtFactory.build
            }.merge(attributes)
          )
        end
      end
    end
  end
end
