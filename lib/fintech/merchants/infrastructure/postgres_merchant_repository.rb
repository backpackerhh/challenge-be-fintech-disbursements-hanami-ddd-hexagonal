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
