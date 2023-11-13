# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class TimeValueObject < ValueObject
        def initialize(new_value)
          super(value: parse_time(new_value[:value]))

          if !valid?
            raise InvalidArgumentError, "'#{value}' is not a valid time"
          end
        end

        private

        def parse_time(value)
          Time.parse(value.to_s)
        rescue ArgumentError
          nil
        end

        def valid?
          !value.nil?
        end
      end
    end
  end
end
