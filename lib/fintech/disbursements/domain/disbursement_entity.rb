# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementEntity < Shared::Domain::AggregateRoot
        attr_reader :id,
                    :merchant_id,
                    :reference,
                    :amount,
                    :commissions_amount,
                    :order_ids,
                    :start_date,
                    :end_date,
                    :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id, SecureRandom.uuid),
              merchant_id: attributes.fetch(:merchant_id),
              reference: attributes.fetch(:reference, SecureRandom.alphanumeric(12)),
              amount: attributes.fetch(:amount),
              commissions_amount: attributes.fetch(:commissions_amount),
              order_ids: attributes.fetch(:order_ids),
              start_date: attributes.fetch(:start_date),
              end_date: attributes.fetch(:end_date),
              created_at: attributes.fetch(:created_at, Time.now))
        end

        def initialize(id:,
                       merchant_id:,
                       reference:,
                       amount:,
                       commissions_amount:,
                       order_ids:,
                       start_date:,
                       end_date:,
                       created_at:)
          super()
          @id = DisbursementIdValueObject.new(value: id)
          @merchant_id = DisbursementMerchantIdValueObject.new(value: merchant_id)
          @reference = DisbursementReferenceValueObject.new(value: reference)
          @amount = DisbursementAmountValueObject.new(value: amount)
          @commissions_amount = DisbursementCommissionsAmountValueObject.new(value: commissions_amount)
          @order_ids = DisbursementOrderIdsValueObject.new(value: order_ids)
          @start_date = DisbursementStartDateValueObject.new(value: start_date)
          @end_date = DisbursementEndDateValueObject.new(value: end_date)
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
            start_date: start_date.value,
            end_date: end_date.value,
            created_at: created_at.value
          }
        end
      end
    end
  end
end
