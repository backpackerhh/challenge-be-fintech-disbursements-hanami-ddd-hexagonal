# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Application
      class FindMonthlyOrderCommissionsUseCase < Shared::Application::UseCase
        repository "order_commissions.repository", Domain::OrderCommissionRepository::Interface
        logger

        def sum_monthly_amount(merchant_id:, date:)
          monthly_amount = repository.monthly_amount(merchant_id:, date:)

          logger.info("Monthly order commissions for merchant #{merchant_id} successfully retrieved (#{date})")

          monthly_amount
        end
      end
    end
  end
end
