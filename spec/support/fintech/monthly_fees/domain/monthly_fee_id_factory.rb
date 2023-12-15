# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
