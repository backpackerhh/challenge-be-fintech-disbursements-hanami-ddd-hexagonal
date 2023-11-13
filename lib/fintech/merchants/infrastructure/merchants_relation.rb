# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Merchants
    module Infrastructure
      class MerchantsRelation < ROM::Relation[:sql]
        schema :merchants, infer: true
      end
    end
  end
end
