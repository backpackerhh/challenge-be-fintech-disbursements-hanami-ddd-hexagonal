# frozen_string_literal: true

module Fintech
  module Disbursements
    module Application
      class CreateDisbursementUseCase < Shared::Application::UseCase
        repository "disbursements.repository", Domain::DisbursementRepository::Interface
        logger
        event_bus

        def create(attributes)
          disbursement = Domain::DisbursementEntity.from_primitives(attributes.transform_keys(&:to_sym))

          repository.create(disbursement.to_primitives)

          logger.info("Disbursement #{disbursement.id.value} successfully created")

          event_bus.publish(Domain::DisbursementCreatedEvent.from(disbursement))
        end
      end
    end
  end
end
