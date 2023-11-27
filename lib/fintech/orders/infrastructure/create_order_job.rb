# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class CreateOrderJob < Shared::Infrastructure::Job
        sidekiq_options queue: "import_data", unique: true, retry_for: 3600 # 1 hour

        def perform(order_attributes)
          Application::CreateOrderUseCase.new.create(order_attributes)

          logger.info("Order #{order_attributes['id']} successfully created")
        end
      end
    end
  end
end
