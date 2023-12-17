# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :disbursements do
      add_index :merchant_id
      add_index %i[start_date end_date]
    end
  end

  down do
    alter_table :disbursements do
      drop_index :merchant_id
      drop_index %i[start_date end_date]
    end
  end
end
