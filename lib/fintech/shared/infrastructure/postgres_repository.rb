# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Shared
    module Infrastructure
      class PostgresRepository
        include Deps["persistence.rom", "persistence.db"]
        include DatabaseExceptionHandler
      end
    end
  end
end
