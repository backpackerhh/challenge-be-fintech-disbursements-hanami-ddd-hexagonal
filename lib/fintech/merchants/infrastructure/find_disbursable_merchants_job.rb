# frozen_string_literal: true

module Fintech
  module Merchants
    module Infrastructure
      class FindDisbursableMerchantsJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        def perform
          # TODO
        end
      end
    end
  end
end
