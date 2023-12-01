# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table :order_commissions do
      column :id, :uuid, primary_key: true
      column :order_amount, "decimal(10, 2)", null: false
      column :amount, "decimal(10, 2)", null: false
      column :fee, "decimal(5, 2)", null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
      foreign_key :order_id, :orders, type: :uuid, null: false, unique: true
    end
  end

  down do
    drop_table? :order_commissions
  end
end
