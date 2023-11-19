# frozen_string_literal: true

require "dry-struct"

module Fintech
  module Shared
    module Domain
      class ValueObject < Dry::Struct
        transform_keys(&:to_sym)

        def self.value_type(type)
          attribute :value, type
        end

        def initialize(*)
          super

          if !respond_to?(:value)
            raise NotImplementedError, "Define the type for the value object with .value_type class method"
          end
        end
      end
    end
  end
end
