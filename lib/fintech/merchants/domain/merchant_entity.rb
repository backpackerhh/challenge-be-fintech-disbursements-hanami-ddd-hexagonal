# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantEntity
        attr_reader :id, :email, :reference, :disbursement_frequency, :live_on, :minimum_monthly_fee, :created_at

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              email: attributes.fetch(:email),
              reference: attributes.fetch(:reference),
              disbursement_frequency: attributes.fetch(:disbursement_frequency),
              live_on: attributes.fetch(:live_on),
              minimum_monthly_fee: attributes.fetch(:minimum_monthly_fee),
              created_at: attributes.fetch(:created_at, Time.now))
        end

        def initialize(id:,
                       email:,
                       reference:,
                       disbursement_frequency:,
                       live_on:,
                       minimum_monthly_fee:,
                       created_at: Time.now)
          @id = MerchantIdValueObject.new(value: id)
          @email = MerchantEmailValueObject.new(value: email)
          @reference = MerchantReferenceValueObject.new(value: reference)
          @disbursement_frequency = MerchantDisbursementFrequencyValueObject.new(value: disbursement_frequency)
          @live_on = MerchantLiveOnValueObject.new(value: live_on)
          @minimum_monthly_fee = MerchantMinimumMonthlyFeeValueObject.new(value: minimum_monthly_fee)
          @created_at = MerchantCreatedAtValueObject.new(value: created_at)
        end

        def to_primitives
          {
            id: id.value,
            email: email.value,
            reference: reference.value,
            disbursement_frequency: disbursement_frequency.value,
            live_on: live_on.value,
            minimum_monthly_fee: minimum_monthly_fee.value,
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
