# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersIdsFactory
        def self.build(value = [SecureRandom.uuid, SecureRandom.uuid])
          value
        end
      end
    end
  end
end
