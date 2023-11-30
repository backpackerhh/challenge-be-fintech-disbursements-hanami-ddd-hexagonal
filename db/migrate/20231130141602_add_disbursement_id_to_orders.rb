# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :orders do
      add_foreign_key :disbursement_id, :disbursements, type: :uuid, null: true
    end
  end

  down do
    alter_table :orders do
      drop_foreign_key :disbursement_id
    end
  end
end
