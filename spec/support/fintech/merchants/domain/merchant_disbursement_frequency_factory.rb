# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantDisbursementFrequencyFactory
        def self.build(value = MerchantDisbursementFrequencyValueObject::ALLOWED_VALUES.sample)
          value
        end
      end
    end
  end
end
