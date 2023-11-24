# frozen_string_literal: true

namespace :fintech do
  namespace :merchants do
    desc "Import merchants from given file path (parameters: FILE_PATH)"
    task :import, [:file_path] => [:environment] do |_t, args|
      # TODO
    end
  end
end
