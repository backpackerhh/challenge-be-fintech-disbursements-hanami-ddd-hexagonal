# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantEntityFactory
        Factory.define(:merchant) do |f|
          f.id { Fintech::Merchants::Domain::MerchantIdFactory.build }
          f.reference { Fintech::Merchants::Domain::MerchantReferenceFactory.build }
          f.email { Fintech::Merchants::Domain::MerchantEmailFactory.build }
          f.disbursement_frequency { Fintech::Merchants::Domain::MerchantDisbursementFrequencyFactory.build }
          f.live_on { Fintech::Merchants::Domain::MerchantLiveOnFactory.build }
          f.minimum_monthly_fee { Fintech::Merchants::Domain::MerchantMinimumMonthlyFeeFactory.build }
          f.created_at { Fintech::Merchants::Domain::MerchantCreatedAtFactory.build }
        end

        def self.build(attributes = {})
          merchant = Factory.structs[:merchant, **attributes]

          MerchantEntity.from_primitives(merchant.to_h)
        end

        def self.create(attributes = {})
          merchant = Factory[:merchant, **attributes]

          MerchantEntity.from_primitives(merchant.to_h)
        end
      end
    end
  end
end
