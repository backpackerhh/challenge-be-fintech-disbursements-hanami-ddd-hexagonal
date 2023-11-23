# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :merchants do
      set_column_type :minimum_monthly_fee, "decimal(10, 2)"
    end
  end

  down do
    alter_table :merchants do
      set_column_type :minimum_monthly_fee, "decimal(5, 2)"
    end
  end
end
