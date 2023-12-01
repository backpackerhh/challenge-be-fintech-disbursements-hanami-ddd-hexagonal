# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionAmountFactory
        def self.build(value = rand(200))
          value
        end
      end
    end
  end
end
