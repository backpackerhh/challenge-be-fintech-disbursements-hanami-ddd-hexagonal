# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :order_commissions do
      add_index :order_id
    end
  end

  down do
    alter_table :order_commissions do
      drop_index :order_id
    end
  end
end
