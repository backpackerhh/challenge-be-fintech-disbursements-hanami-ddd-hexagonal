# frozen_string_literal: true

namespace :fintech do
  namespace :merchants do
    desc "Import merchants from given file path (parameters: FILE_PATH)"
    task :import, [:file_path] => [:environment] do |_t, args|
      if args.file_path.nil?
        raise Fintech::Shared::Application::MissingFilePathError, "No file path given"
      end

      if !File.exist?(args.file_path)
        raise Fintech::Shared::Application::FileNotFoundError, "File not found"
      end

      supported_file_extensions = %w[.csv]
      file_extension = File.extname(args.file_path)

      if !supported_file_extensions.include?(file_extension)
        raise Fintech::Shared::Application::UnsupportedFileError,
              "Supported files: #{supported_file_extensions.join(', ')}"
      end

      Fintech::Merchants::Infrastructure::ImportMerchantsJob.perform_async(args.file_path)

      Hanami.logger.info("Job enqueued to import merchants from #{args.file_path}")
    rescue Fintech::Shared::Application::MissingFilePathError,
           Fintech::Shared::Application::FileNotFoundError,
           Fintech::Shared::Application::UnsupportedFileError => e
      puts e.inspect
      puts "Example usage: rake fintech:merchants:import[<file_path>]"
    end
  end
end
