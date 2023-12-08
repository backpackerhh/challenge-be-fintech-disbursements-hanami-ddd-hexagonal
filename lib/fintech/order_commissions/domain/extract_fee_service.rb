# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class ExtractFeeService < Shared::Domain::Service
        FEE_TIERS = {
          0.0...50.0 => BigDecimal("1.0"),
          50.0...300.0 => BigDecimal("0.95"),
          300.0... => BigDecimal("0.85")
        }.freeze

        attribute :order_amount, Types::Params::Decimal

        def fee
          FEE_TIERS.detect { |fee_tier, _fee| fee_tier === order_amount }.last
        end
      end
    end
  end
end
