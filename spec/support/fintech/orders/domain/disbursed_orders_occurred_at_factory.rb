# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class DisbursedOrdersOccurredAtFactory
        def self.build(value = Time.now)
          value
        end
      end
    end
  end
end
