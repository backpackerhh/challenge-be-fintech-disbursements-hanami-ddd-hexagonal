# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementCommissionsAmountFactory
        def self.build(value = rand(2000), percentage = 0.15)
          value * percentage
        end
      end
    end
  end
end
