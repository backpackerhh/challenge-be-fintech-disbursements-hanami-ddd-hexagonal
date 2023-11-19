# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantDisbursementFrequencyValueObject < Shared::Domain::EnumValueObject
        DAILY = "DAILY"
        WEEKLY = "WEEKLY"

        allowed_values [DAILY, WEEKLY]
      end
    end
  end
end
