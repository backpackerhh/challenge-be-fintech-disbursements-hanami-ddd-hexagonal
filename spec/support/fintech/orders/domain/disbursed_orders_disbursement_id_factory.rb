# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersDisbursementIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
