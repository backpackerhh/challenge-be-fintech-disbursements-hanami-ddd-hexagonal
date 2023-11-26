# frozen_string_literal: true

require_relative "../task_helpers"

namespace :fintech do
  namespace :merchants do
    desc "Import merchants from given file path (parameters: FILE_PATH)"
    task :import, [:file_path] => [:environment] do |_t, args|
      example_usage = "rake fintech:merchants:import[<file_path>]"

      Fintech::TaskHelpers.handle_import_data_from_file(args.file_path, example_usage) do
        Fintech::Merchants::Infrastructure::ImportMerchantsJob.perform_async(args.file_path)

        Hanami.logger.info("Job enqueued to import merchants from #{args.file_path}")
      end
    end
  end
end
