# frozen_string_literal: true

ROM::SQL.migration do
  up do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""
  end

  down do
    execute "DROP EXTENSION IF EXISTS \"uuid-ossp\""
  end
end
