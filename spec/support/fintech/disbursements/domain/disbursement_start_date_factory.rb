# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementStartDateFactory
        def self.build(value = Date.today - 1)
          value
        end
      end
    end
  end
end
