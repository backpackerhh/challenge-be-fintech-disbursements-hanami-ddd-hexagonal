# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Orders
    module Infrastructure
      class OrdersRelation < ROM::Relation[:sql]
        schema :orders, infer: true
      end
    end
  end
end
