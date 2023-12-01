# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionFeeFactory
        def self.build(value = rand(10))
          value
        end
      end
    end
  end
end
