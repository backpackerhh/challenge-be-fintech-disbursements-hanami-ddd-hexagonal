# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionOrderAmountFactory
        def self.build(value = rand(2000))
          value
        end
      end
    end
  end
end
