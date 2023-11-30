# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementCreatedAtFactory
        def self.build(value = Time.now)
          value
        end
      end
    end
  end
end
