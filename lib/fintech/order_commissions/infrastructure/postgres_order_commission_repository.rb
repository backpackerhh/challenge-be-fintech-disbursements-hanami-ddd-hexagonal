# frozen_string_literal: true

require "rom-sql"

module Fintech
  module OrderCommissions
    module Infrastructure
      class PostgresOrderCommissionRepository
        include Deps["persistence.rom", "persistence.db", "logger"]

        def all
          order_commissions = rom.relations[:order_commissions].to_a

          order_commissions.map { |order_commission| Domain::OrderCommissionEntity.from_primitives(order_commission) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:order_commissions].insert(attributes)
          end
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end

        def exists?(attributes)
          rom.relations[:order_commissions].exist?(attributes)
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
