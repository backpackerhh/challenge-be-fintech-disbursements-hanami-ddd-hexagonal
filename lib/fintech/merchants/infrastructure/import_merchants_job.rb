# frozen_string_literal: true

require "csv"

module Fintech
  module Merchants
    module Infrastructure
      class ImportMerchantsJob < Shared::Infrastructure::Job
        sidekiq_options queue: "import_data", unique: true, retry_for: 3600 # 1 hour

        def perform(file_path)
          raw_merchants = CSV.read(file_path, headers: true, col_sep: ";")

          raw_merchants.each_with_index do |raw_merchant, idx|
            delay = idx * 2 # in seconds

            CreateMerchantJob.perform_in(Time.now + delay, raw_merchant.to_h)

            logger.info("Job enqueued for creating merchant #{raw_merchant['id']}")
          end
        rescue StandardError => e # rescue generic exception due to great variety of exceptions that could be raised
          logger.error("Found error processing given file (#{file_path}): #{e.message}")
        end
      end
    end
  end
end
