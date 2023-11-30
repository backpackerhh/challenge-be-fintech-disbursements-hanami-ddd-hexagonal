# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      class DisbursementReferenceValueObject < Shared::Domain::StringValueObject
        value_type Types::Strict::String.constrained(size: 12)
      end
    end
  end
end
