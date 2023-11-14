# frozen_string_literal: true

ROM::SQL.migration do
  up do
    execute "CREATE TYPE merchant_disbursement_frequency_enum AS ENUM ('DAILY', 'WEEKLY')"

    create_table :merchants do
      column :id, :uuid, primary_key: true
      column :email, "varchar(100)", null: false
      column :reference, "varchar(100)", null: false, unique: true
      column :disbursement_frequency, :merchant_disbursement_frequency_enum, null: false
      column :live_on, :date, null: false
      column :minimum_monthly_fee, "decimal(5, 2)", null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
    end
  end

  down do
    drop_table? :merchants

    execute "DROP TYPE IF EXISTS merchant_disbursement_frequency_enum"
  end
end
