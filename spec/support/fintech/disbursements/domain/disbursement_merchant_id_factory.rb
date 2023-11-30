# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementMerchantIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
