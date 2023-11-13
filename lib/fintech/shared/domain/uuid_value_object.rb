# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class UuidValueObject < ValueObject
        def initialize(new_value)
          super(new_value)

          if !valid?
            raise InvalidArgumentError, "'#{value}' is not a valid UUID"
          end
        end

        private

        # https://www.rubydoc.info/gems/uuid/2.3.9/UUID.validate
        def valid?
          /\A([\da-f]{32})|((urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12})\z/.match?(value.to_s.downcase)
        end
      end
    end
  end
end
