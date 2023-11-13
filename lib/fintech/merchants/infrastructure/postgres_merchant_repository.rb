# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Merchants
    module Infrastructure
      class PostgresMerchantRepository < Domain::MerchantRepository
        include Deps["persistence.rom", "logger"]

        def all
          merchants = rom.relations[:merchants].to_a

          merchants.map { |merchant| Domain::MerchantEntity.from_primitives(merchant) }
        end

        def create(attributes)
          rom.relations[:merchants].insert(attributes)
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end

        def bulk_create(attributes)
          rom.relations[:merchants].multi_insert(attributes)
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
