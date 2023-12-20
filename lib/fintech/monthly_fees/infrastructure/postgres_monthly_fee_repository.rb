# frozen_string_literal: true

module Fintech
  module MonthlyFees
    module Infrastructure
      class PostgresMonthlyFeeRepository < Shared::Infrastructure::PostgresRepository
        def all
          monthly_fees = rom.relations[:monthly_fees].to_a

          monthly_fees.map { |monthly_fee| Domain::MonthlyFeeEntity.from_primitives(monthly_fee) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:monthly_fees].insert(attributes)
          end
        end
      end
    end
  end
end
