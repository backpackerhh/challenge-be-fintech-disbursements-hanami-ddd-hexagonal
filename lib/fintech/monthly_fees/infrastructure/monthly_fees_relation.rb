# frozen_string_literal: true

require "rom-sql"

module Fintech
  module MonthlyFees
    module Infrastructure
      class MonthlyFeesRelation < ROM::Relation[:sql]
        schema :monthly_fees, infer: true
      end
    end
  end
end
