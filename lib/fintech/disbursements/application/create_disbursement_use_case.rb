# frozen_string_literal: true

module Fintech
  module Disbursements
    module Application
      class CreateDisbursementUseCase < Shared::Application::UseCase
        repository "disbursements.repository", Domain::DisbursementRepository::Interface
        logger
        event_bus
        finder_use_case "merchants.find.use_case"

        def create(attributes)
          attributes = attributes.transform_keys(&:to_sym)
          merchant_id = attributes.fetch(:merchant_id)

          finder_use_case.find(merchant_id)

          disbursement = Domain::DisbursementEntity.from_primitives(attributes)

          repository.create(disbursement.to_primitives)

          logger.info("Disbursement #{disbursement.id.value} successfully created for merchant #{merchant_id}")

          event_bus.publish(Domain::DisbursementCreatedEvent.from(disbursement))
        end
      end
    end
  end
end
