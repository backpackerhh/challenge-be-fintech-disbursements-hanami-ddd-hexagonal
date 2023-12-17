# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :orders do
      add_index :merchant_id
      add_index :created_at
    end
  end

  down do
    alter_table :orders do
      drop_index :merchant_id
      drop_index :created_at
    end
  end
end
