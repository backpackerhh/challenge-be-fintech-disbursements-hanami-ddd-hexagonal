# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementEntityFactory
        Factory.define(:disbursement) do |f|
          f.id { DisbursementIdFactory.build }
          f.merchant_id { DisbursementMerchantIdFactory.build }
          f.reference { DisbursementReferenceFactory.build }
          f.amount { DisbursementAmountFactory.build }
          f.commissions_amount { |amount| DisbursementCommissionsAmountFactory.build(amount) }
          f.order_ids { DisbursementOrderIdsFactory.build }
          f.start_date { DisbursementStartDateFactory.build }
          f.end_date { DisbursementEndDateFactory.build }
          f.created_at { DisbursementCreatedAtFactory.build }
        end

        def self.build(*traits, **attributes)
          disbursement = Factory.structs[:disbursement, *traits, **attributes]

          DisbursementEntity.from_primitives(disbursement.to_h)
        end

        def self.create(*traits, **attributes)
          disbursement = Factory[:disbursement, *traits, **attributes]

          DisbursementEntity.from_primitives(disbursement.to_h)
        end
      end
    end
  end
end
