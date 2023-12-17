# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Disbursements
    module Infrastructure
      class PostgresDisbursementRepository
        include Deps["persistence.rom", "persistence.db", "logger"]

        def all
          disbursements = rom.relations[:disbursements].to_a

          disbursements.map { |disbursement| Domain::DisbursementEntity.from_primitives(disbursement) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:disbursements].insert(
              attributes.merge(order_ids: Sequel.pg_array(attributes[:order_ids], :uuid))
            )
          end
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end

        def first_in_month_for_merchant?(merchant_id:, start_date:)
          result = db[
            <<~SQL
              SELECT COUNT(*)
              FROM disbursements
              WHERE merchant_id = '#{merchant_id}'
              AND start_date >= DATE_TRUNC('month', DATE('#{start_date}'))
              AND end_date < (DATE_TRUNC('month', DATE('#{start_date}')) + INTERVAL '1 month')
            SQL
          ]

          result.to_a[0][:count] == 1
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
