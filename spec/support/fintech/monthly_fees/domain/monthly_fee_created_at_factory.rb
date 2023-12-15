# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeCreatedAtFactory
        def self.build(value = Time.now)
          value
        end
      end
    end
  end
end
