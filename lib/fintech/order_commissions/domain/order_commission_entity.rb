# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionEntity < Shared::Domain::AggregateRoot
        attr_reader :id, :order_id, :order_amount, :fee, :amount, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id, SecureRandom.uuid),
              order_id: attributes.fetch(:order_id),
              order_amount: attributes.fetch(:order_amount),
              fee: attributes.fetch(
                :fee,
                ExtractFeeService.new(order_amount: attributes.fetch(:order_amount)).fee
              ),
              amount: attributes.fetch(
                :amount,
                CalculateAmountService.new(order_amount: attributes.fetch(:order_amount)).amount
              ),
              created_at: attributes.fetch(:created_at, Time.now))
        end

        def initialize(id:, order_id:, order_amount:, fee:, amount:, created_at:)
          super()
          @id = OrderCommissionIdValueObject.new(value: id)
          @order_id = OrderCommissionOrderIdValueObject.new(value: order_id)
          @order_amount = OrderCommissionOrderAmountValueObject.new(value: order_amount)
          @fee = OrderCommissionFeeValueObject.new(value: fee)
          @amount = OrderCommissionAmountValueObject.new(value: amount)
          @created_at = OrderCommissionCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            order_id: order_id.value,
            order_amount: order_amount.value,
            fee: fee.value,
            amount: amount.value,
            created_at: created_at.value
          }
        end
      end
    end
  end
end
