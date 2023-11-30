# frozen_string_literal: true

ROM::SQL.migration do
  up do
    execute <<~SQL
      CREATE OR REPLACE FUNCTION update_disbursement_id()
      RETURNS TRIGGER AS $$
      BEGIN
          UPDATE public.orders
          SET disbursement_id = NULL
          WHERE id = ANY(OLD.order_ids);

          UPDATE public.orders
          SET disbursement_id = NEW.id
          WHERE id = ANY(NEW.order_ids);

          RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER disbursement_update_trigger
      AFTER INSERT OR UPDATE OF order_ids
      ON public.disbursements
      FOR EACH ROW
      EXECUTE FUNCTION update_disbursement_id();
    SQL
  end

  down do
    execute <<~SQL
      DROP TRIGGER IF EXISTS disbursement_update_trigger ON public.disbursements;
      DROP FUNCTION IF EXISTS update_disbursement_id() CASCADE;
    SQL
  end
end
