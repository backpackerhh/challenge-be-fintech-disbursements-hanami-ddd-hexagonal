# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionEntity
        attr_reader :id, :order_id, :order_amount, :amount, :fee, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              order_id: attributes.fetch(:order_id),
              order_amount: attributes.fetch(:order_amount),
              amount: attributes.fetch(:amount),
              fee: attributes.fetch(:fee),
              created_at: attributes.fetch(:created_at))
        end

        def initialize(id:, order_id:, order_amount:, amount:, fee:, created_at:)
          @id = OrderCommissionIdValueObject.new(value: id)
          @order_id = OrderCommissionOrderIdValueObject.new(value: order_id)
          @order_amount = OrderCommissionOrderAmountValueObject.new(value: order_amount)
          @amount = OrderCommissionAmountValueObject.new(value: amount)
          @fee = OrderCommissionFeeValueObject.new(value: fee)
          @created_at = OrderCommissionCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            order_id: order_id.value,
            order_amount: order_amount.value,
            amount: amount.value,
            fee: fee.value,
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
