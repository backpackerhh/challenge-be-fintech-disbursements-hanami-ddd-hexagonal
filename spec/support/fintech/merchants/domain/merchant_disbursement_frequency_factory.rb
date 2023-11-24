# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantDisbursementFrequencyFactory
        def self.build(value = MerchantDisbursementFrequencyValueObject::ALLOWED_VALUES.sample)
          value
        end

        def self.daily
          MerchantDisbursementFrequencyValueObject::DAILY
        end

        def self.weekly
          MerchantDisbursementFrequencyValueObject::WEEKLY
        end
      end
    end
  end
end
