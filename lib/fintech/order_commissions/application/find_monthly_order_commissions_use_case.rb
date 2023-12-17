# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Application
      class FindMonthlyOrderCommissionsUseCase < Shared::Application::UseCase
        repository "order_commissions.repository", Domain::OrderCommissionRepository::Interface
        logger

        def sum_monthly_amount(merchant_id:, beginning_of_month:)
          monthly_amount = repository.monthly_amount(merchant_id:, beginning_of_month:)

          logger.info(
            "Monthly order commissions for merchant #{merchant_id} successfully retrieved (#{beginning_of_month})"
          )

          monthly_amount
        end
      end
    end
  end
end
