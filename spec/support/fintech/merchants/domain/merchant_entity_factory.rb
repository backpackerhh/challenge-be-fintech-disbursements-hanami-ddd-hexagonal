# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantEntityFactory
        Factory.define(:merchant) do |f|
          f.id { MerchantIdFactory.build }
          f.reference { MerchantReferenceFactory.build }
          f.email { MerchantEmailFactory.build }
          f.disbursement_frequency { MerchantDisbursementFrequencyFactory.build }
          f.live_on { MerchantLiveOnFactory.build }
          f.minimum_monthly_fee { MerchantMinimumMonthlyFeeFactory.build }
          f.created_at { MerchantCreatedAtFactory.build }
        end

        def self.build(*traits, **attributes)
          merchant = Factory.structs[:merchant, *traits, **attributes]

          MerchantEntity.from_primitives(merchant.to_h)
        end

        def self.create(*traits, **attributes)
          merchant = Factory[:merchant, *traits, **attributes]

          MerchantEntity.from_primitives(merchant.to_h)
        end
      end
    end
  end
end
