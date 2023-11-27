# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderAmountFactory
        def self.build(value = rand(200))
          value
        end
      end
    end
  end
end
