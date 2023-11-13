# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class EmailValueObject < ValueObject
        def initialize(new_value)
          super(new_value)

          if !valid?
            raise InvalidArgumentError, "'#{value}' is not a valid email"
          end
        end

        private

        def valid?
          URI::MailTo::EMAIL_REGEXP.match?(value)
        end
      end
    end
  end
end
