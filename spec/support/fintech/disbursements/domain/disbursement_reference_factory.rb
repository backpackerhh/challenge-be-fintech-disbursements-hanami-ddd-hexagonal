# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementReferenceFactory
        def self.build(value = Faker::Alphanumeric.alpha(number: 12))
          value
        end
      end
    end
  end
end
