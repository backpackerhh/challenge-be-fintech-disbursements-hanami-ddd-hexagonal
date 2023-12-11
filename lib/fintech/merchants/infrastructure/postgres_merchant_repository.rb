# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Merchants
    module Infrastructure
      class PostgresMerchantRepository
        include Deps["persistence.rom", "persistence.db", "logger"]

        def all
          merchants = rom.relations[:merchants].to_a

          merchants.map { |merchant| Domain::MerchantEntity.from_primitives(merchant) }
        end

        def grouped_disbursable_ids
          grouped_merchant_ids = db[
            <<~SQL
              SELECT ARRAY_AGG(id) AS merchant_ids, disbursement_frequency
              FROM merchants
              WHERE disbursement_frequency = '#{Domain::MerchantDisbursementFrequencyValueObject::DAILY}'
              OR (
                disbursement_frequency = '#{Domain::MerchantDisbursementFrequencyValueObject::WEEKLY}' AND
                DATE_PART('isodow', live_on) = DATE_PART('isodow', DATE '#{Date.today}')
              )
              GROUP BY disbursement_frequency
            SQL
          ]

          grouped_merchant_ids.to_a.each_with_object({}) do |row, results|
            results[row[:disbursement_frequency]] = row[:merchant_ids]
          end
        end

        def create(attributes)
          db.transaction do
            rom.relations[:merchants].insert(attributes)
          end
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
