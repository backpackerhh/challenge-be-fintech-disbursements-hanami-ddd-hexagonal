# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class PercentageValueObject < ValueObject
        def initialize(new_value)
          super(value: new_value[:value].to_s.to_d)

          if !valid?
            raise InvalidArgumentError, "'#{value}' is not a valid percentage"
          end
        end

        private

        def valid?
          value >= 0.0 && value <= 100.0
        end
      end
    end
  end
end
