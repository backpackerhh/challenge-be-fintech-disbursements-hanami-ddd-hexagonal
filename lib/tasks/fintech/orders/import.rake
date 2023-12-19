# frozen_string_literal: true

require_relative "../task_helpers"

namespace :fintech do
  namespace :orders do
    desc "[OTT] Import orders from given file path (parameters: FILE_PATH)"
    task :import, [:file_path] => [:environment] do |_t, args|
      example_usage = "rake fintech:orders:import[<file_path>]"

      Fintech::TaskHelpers.handle_import_data_from_file(args.file_path, example_usage) do
        Fintech::Orders::Infrastructure::ImportOrdersJob.perform_async(args.file_path)

        Hanami.logger.info("Job enqueued to import orders from #{args.file_path}")
      end
    end
  end
end
