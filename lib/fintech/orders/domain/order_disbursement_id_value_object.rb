# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class OrderDisbursementIdValueObject < Shared::Domain::UuidValueObject
        value_type Types::Strict::String.constrained(uuid_v4: true).optional
      end
    end
  end
end
