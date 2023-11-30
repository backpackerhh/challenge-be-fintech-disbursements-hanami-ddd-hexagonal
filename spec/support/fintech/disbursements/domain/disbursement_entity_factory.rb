# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementEntityFactory
        Factory.define(:disbursement) do |f|
          f.id { Fintech::Disbursements::Domain::DisbursementIdFactory.build }
          f.merchant_id { Fintech::Disbursements::Domain::DisbursementMerchantIdFactory.build }
          f.reference { Fintech::Disbursements::Domain::DisbursementReferenceFactory.build }
          f.amount { Fintech::Disbursements::Domain::DisbursementAmountFactory.build }
          f.commissions_amount do |amount|
            Fintech::Disbursements::Domain::DisbursementCommissionsAmountFactory.build(amount)
          end
          f.order_ids { Fintech::Disbursements::Domain::DisbursementOrderIdsFactory.build }
          f.created_at { Fintech::Disbursements::Domain::DisbursementCreatedAtFactory.build }
        end

        def self.build(attributes = {})
          disbursement = Factory.structs[:disbursement, **attributes]

          DisbursementEntity.from_primitives(disbursement.to_h)
        end

        def self.create(attributes = {})
          disbursement = Factory[:disbursement, **attributes]

          DisbursementEntity.from_primitives(disbursement.to_h)
        end
      end
    end
  end
end
