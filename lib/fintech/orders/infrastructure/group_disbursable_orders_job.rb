# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class GroupDisbursableOrdersJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        def perform(grouping_type, merchant_id)
          # TODO
        end
      end
    end
  end
end
