# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Orders
    module Infrastructure
      class PostgresOrderRepository
        include Deps["persistence.rom", "persistence.db", "logger"]

        def all
          orders = rom.relations[:orders].to_a

          orders.map { |order| Domain::OrderEntity.from_primitives(order) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:orders].insert(attributes)
          end
        rescue Sequel::DatabaseError => e
          logger.error(e) # maybe re-raise exception, register in Honeybadger or similar platform...
        end
      end
    end
  end
end
