# frozen_string_literal: true

module Fintech
  module Disbursements
    module Application
      class CreateDisbursementUseCase < Shared::Application::UseCase
        repository "disbursements.repository", Domain::DisbursementRepository::Interface
        logger
        event_bus
        finder_service "merchants.find.service"

        def create(attributes, callback:)
          attributes = attributes.transform_keys(&:to_sym)
          merchant_id = attributes.fetch(:merchant_id)

          finder_service.find(merchant_id)

          disbursement = Domain::DisbursementEntity.from_primitives(attributes)

          repository.create(disbursement.to_primitives)

          logger.info("Disbursement #{disbursement.id.value} successfully created for merchant #{merchant_id}")

          event_bus.publish(Domain::DisbursementCreatedEvent.from(disbursement))

          if repository.first_in_month_for_merchant?(merchant_id:, date: disbursement.start_date.value)
            callback.call
          end
        end
      end
    end
  end
end
