# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
