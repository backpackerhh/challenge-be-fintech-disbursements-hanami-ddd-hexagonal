# frozen_string_literal: true

require "smarter_csv"

module Fintech
  module Orders
    module Infrastructure
      class ImportOrdersJob < Shared::Infrastructure::Job
        sidekiq_options queue: "import_data", unique: true, retry_for: 3600 # 1 hour

        include Deps[list_merchants_service: "merchants.list.service"]

        def perform(file_path)
          options = { chunk_size: Hanami.app.settings.import_orders_chunk_size, headers_in_file: true, col_sep: ";" }

          SmarterCSV.process(file_path, options) do |chunk|
            chunk.each do |raw_order|
              raw_order.transform_keys!(&:to_s)
              raw_order["original_id"] = raw_order["id"] # keep the original one for ilustrative purposes only
              raw_order["id"] = SecureRandom.uuid
              raw_order["merchant_id"] = merchants_dictionary[raw_order["merchant_reference"]]
            end

            Sidekiq::Client.push_bulk("class" => CreateOrderJob, "args" => chunk.zip)

            logger.info("Jobs enqueued for creating orders")
          end
        rescue SmarterCSV::SmarterCSVException => e
          logger.error("Found error processing given file (#{file_path}): #{e.message}")
        end

        private

        def merchants_dictionary
          @merchants_dictionary ||= begin
            merchants = list_merchants_service.retrieve_all

            merchants.each_with_object({}) do |merchant, dictionary|
              dictionary[merchant.reference.value] = merchant.id.value
            end
          end
        end
      end
    end
  end
end
