# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementAmountFactory
        def self.build(value = rand(2000))
          value
        end
      end
    end
  end
end
