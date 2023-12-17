# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Infrastructure
      class CreateMonthlyFeeJob < Shared::Infrastructure::Job
        sidekiq_options queue: "disbursements", unique: true, retry_for: 3600 # 1 hour

        def perform(merchant_id, start_date)
          # TODO
        end
      end
    end
  end
end
