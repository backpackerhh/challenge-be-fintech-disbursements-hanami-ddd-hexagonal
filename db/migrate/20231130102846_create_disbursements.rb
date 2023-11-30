# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :disbursements do
      column :id, :uuid, primary_key: true
      column :reference, "varchar(12)", null: false, unique: true
      column :amount, "decimal(10, 2)", null: false
      column :commissions_amount, "decimal(10, 2)", null: false
      column :order_ids, "uuid[]", null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
      foreign_key :merchant_id, :merchants, type: :uuid, null: false
    end
  end

  down do
    drop_table? :disbursements
  end
end
