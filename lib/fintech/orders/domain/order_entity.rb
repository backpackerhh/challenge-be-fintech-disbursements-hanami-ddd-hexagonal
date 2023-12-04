# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderEntity < Shared::Domain::AggregateRoot
        attr_reader :id, :merchant_id, :disbursement_id, :amount, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              merchant_id: attributes.fetch(:merchant_id),
              disbursement_id: attributes.fetch(:disbursement_id, nil),
              amount: attributes.fetch(:amount),
              created_at: attributes.fetch(:created_at))
        end

        def initialize(id:, merchant_id:, disbursement_id:, amount:, created_at:)
          super()
          @id = OrderIdValueObject.new(value: id)
          @merchant_id = OrderMerchantIdValueObject.new(value: merchant_id)
          @disbursement_id = OrderDisbursementIdValueObject.new(value: disbursement_id)
          @amount = OrderAmountValueObject.new(value: amount)
          @created_at = OrderCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            merchant_id: merchant_id.value,
            disbursement_id: disbursement_id.value,
            amount: amount.value,
            created_at: created_at.value
          }
        end
      end
    end
  end
end
