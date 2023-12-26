# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class FindMonthlyOrderCommissionsService < Shared::Domain::Service
        attribute :repository, Domain::OrderCommissionRepository::Interface

        include Deps["order_commissions.repository"]

        def sum_monthly_amount(merchant_id:, date:)
          repository.monthly_amount(merchant_id:, date:)
        end
      end
    end
  end
end
