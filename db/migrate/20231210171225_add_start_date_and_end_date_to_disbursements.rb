# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :disbursements do
      add_column :start_date, :date, null: false
      add_column :end_date, :date, null: false
    end
  end

  down do
    alter_table :disbursements do
      drop_column :start_date
      drop_column :end_date
    end
  end
end
