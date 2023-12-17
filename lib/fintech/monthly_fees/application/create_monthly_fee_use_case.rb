# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Application
      class CreateMonthlyFeeUseCase < Shared::Application::UseCase
        repository "monthly_fees.repository", Domain::MonthlyFeeRepository::Interface
        logger
        event_bus
        finder_use_case "merchants.find.use_case"

        def create(attributes)
          attributes = attributes.transform_keys(&:to_sym)
          merchant_id = attributes.fetch(:merchant_id)

          finder_use_case.find(merchant_id)

          monthly_fee = Domain::MonthlyFeeEntity.from_primitives(attributes)

          repository.create(monthly_fee.to_primitives)

          logger.info("Monthly fee #{monthly_fee.id.value} successfully created for merchant #{merchant_id}")

          event_bus.publish(Domain::MonthlyFeeCreatedEvent.from(monthly_fee))
        end
      end
    end
  end
end
