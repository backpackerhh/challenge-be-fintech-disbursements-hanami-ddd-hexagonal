# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantDisbursementFrequencyValueObject < Shared::Domain::EnumValueObject
        DAILY = "DAILY"
        WEEKLY = "WEEKLY"
        ALLOWED_VALUES = [DAILY, WEEKLY].freeze
      end
    end
  end
end
