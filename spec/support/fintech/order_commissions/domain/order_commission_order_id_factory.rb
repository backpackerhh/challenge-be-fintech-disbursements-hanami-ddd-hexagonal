# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionOrderIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
