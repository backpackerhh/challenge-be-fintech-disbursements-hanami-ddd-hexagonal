# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementEntity
        attr_reader :id, :merchant_id, :reference, :amount, :commissions_amount, :order_ids, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              merchant_id: attributes.fetch(:merchant_id),
              reference: attributes.fetch(:reference),
              amount: attributes.fetch(:amount),
              commissions_amount: attributes.fetch(:commissions_amount),
              order_ids: attributes.fetch(:order_ids),
              created_at: attributes.fetch(:created_at))
        end

        def initialize(id:, merchant_id:, reference:, amount:, commissions_amount:, order_ids:, created_at:)
          @id = DisbursementIdValueObject.new(value: id)
          @merchant_id = DisbursementMerchantIdValueObject.new(value: merchant_id)
          @reference = DisbursementReferenceValueObject.new(value: reference)
          @amount = DisbursementAmountValueObject.new(value: amount)
          @commissions_amount = DisbursementCommissionsAmountValueObject.new(value: commissions_amount)
          @order_ids = DisbursementOrderIdsValueObject.new(value: order_ids)
          @created_at = DisbursementCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            merchant_id: merchant_id.value,
            reference: reference.value,
            amount: amount.value,
            commissions_amount: commissions_amount.value,
            order_ids: order_ids.value,
            created_at: created_at.value
          }
        end

        def ==(other)
          to_primitives == other.to_primitives
        end
      end
    end
  end
end
