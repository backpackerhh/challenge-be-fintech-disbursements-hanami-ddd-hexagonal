# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class EmailValueObject < ValueObject
        value_type Types::Strict::String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end
    end
  end
end
