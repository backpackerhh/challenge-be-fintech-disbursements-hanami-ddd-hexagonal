# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementOrderIdsFactory
        def self.build(value = [SecureRandom.uuid, SecureRandom.uuid])
          value
        end
      end
    end
  end
end
