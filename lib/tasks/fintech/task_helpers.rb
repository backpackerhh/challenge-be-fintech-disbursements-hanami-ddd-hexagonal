# frozen_string_literal: true

module Fintech
  module TaskHelpers
    def self.handle_import_data_from_file(file_path, example_usage, &)
      if file_path.nil?
        raise Fintech::Shared::Application::MissingFilePathError, "No file path given"
      end

      supported_file_extensions = %w[.csv]
      file_extension = File.extname(file_path)

      if !supported_file_extensions.include?(file_extension)
        raise Fintech::Shared::Application::UnsupportedFileError,
              "Supported files: #{supported_file_extensions.join(', ')}"
      end

      if !File.exist?(file_path)
        raise Fintech::Shared::Application::FileNotFoundError, "File not found"
      end

      yield
    rescue Fintech::Shared::Application::MissingFilePathError,
           Fintech::Shared::Application::FileNotFoundError,
           Fintech::Shared::Application::UnsupportedFileError => e
      puts e.inspect
      puts "Example usage: #{example_usage}"
    end
  end
end
