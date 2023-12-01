# frozen_string_literal: true

require "rom-sql"

module Fintech
  module OrderCommissions
    module Infrastructure
      class OrderCommissionsRelation < ROM::Relation[:sql]
        schema :order_commissions, infer: true
      end
    end
  end
end
