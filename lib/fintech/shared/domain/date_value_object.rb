# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class DateValueObject < ValueObject
        def initialize(new_value)
          super(value: parse_date(new_value[:value]))

          if !valid?
            raise InvalidArgumentError, "'#{value}' is not a valid date"
          end
        end

        private

        def parse_date(value)
          Date.parse(value.to_s)
        rescue Date::Error
          nil
        end

        def valid?
          !value.nil?
        end
      end
    end
  end
end
