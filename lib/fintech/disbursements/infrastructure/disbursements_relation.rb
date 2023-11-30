# frozen_string_literal: true

require "rom-sql"

module Fintech
  module Disbursements
    module Infrastructure
      class DisbursementsRelation < ROM::Relation[:sql]
        schema :disbursements, infer: true
      end
    end
  end
end
