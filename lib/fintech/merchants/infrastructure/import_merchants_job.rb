# frozen_string_literal: true

module Fintech
  module Merchants
    module Infrastructure
      class ImportMerchantsJob < Shared::Infrastructure::Job
        sidekiq_options queue: "import_data", unique: true, retry_for: 3600 # 1 hour

        def perform(file_path)
          # TODO
        end
      end
    end
  end
end
