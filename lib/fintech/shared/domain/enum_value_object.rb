# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class EnumValueObject < ValueObject
        def initialize(new_value)
          super(new_value)

          if !valid?
            raise InvalidArgumentError,
                  "'#{value}' is not valid. Allowed values are: #{self.class::ALLOWED_VALUES.join(', ')}"
          end
        end

        private

        def valid?
          self.class::ALLOWED_VALUES.include?(value)
        end
      end
    end
  end
end
