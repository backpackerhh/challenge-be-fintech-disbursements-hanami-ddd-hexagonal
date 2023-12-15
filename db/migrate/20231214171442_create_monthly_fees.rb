# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :monthly_fees do
      column :id, :uuid, primary_key: true
      column :amount, "decimal(10, 2)", null: false
      column :commissions_amount, "decimal(10, 2)", null: false
      column :month, "varchar(7)", null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
      foreign_key :merchant_id, :merchants, type: :uuid, null: false, index: true
    end
  end

  down do
    drop_table? :monthly_fees
  end
end
