# frozen_string_literal: true

require "rom-sql"

module Fintech
  module MonthlyFees
    module Infrastructure
      class PostgresMonthlyFeeRepository
        include Deps["persistence.rom", "persistence.db", "logger"]

        def all
          monthly_fees = rom.relations[:monthly_fees].to_a

          monthly_fees.map { |monthly_fee| Domain::MonthlyFeeEntity.from_primitives(monthly_fee) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:monthly_fees].insert(attributes)
          end
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
