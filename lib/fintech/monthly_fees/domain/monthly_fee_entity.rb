# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Domain
      class MonthlyFeeEntity < Shared::Domain::AggregateRoot
        attr_reader :id, :merchant_id, :amount, :commissions_amount, :month, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id, SecureRandom.uuid),
              merchant_id: attributes.fetch(:merchant_id),
              amount: attributes.fetch(:amount),
              commissions_amount: attributes.fetch(:commissions_amount),
              month: attributes.fetch(:month),
              created_at: attributes.fetch(:created_at, Time.now))
        end

        def initialize(id:, merchant_id:, amount:, commissions_amount:, month:, created_at:)
          super()
          @id = MonthlyFeeIdValueObject.new(value: id)
          @merchant_id = MonthlyFeeMerchantIdValueObject.new(value: merchant_id)
          @amount = MonthlyFeeAmountValueObject.new(value: amount)
          @commissions_amount = MonthlyFeeCommissionsAmountValueObject.new(value: commissions_amount)
          @month = MonthlyFeeMonthValueObject.new(value: month)
          @created_at = MonthlyFeeCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            merchant_id: merchant_id.value,
            amount: amount.value,
            commissions_amount: commissions_amount.value,
            month: month.value,
            created_at: created_at.value
          }
        end
      end
    end
  end
end
