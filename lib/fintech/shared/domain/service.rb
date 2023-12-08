# frozen_string_literal: true

require "dry/struct"

module Fintech
  module Shared
    module Domain
      class Service < Dry::Struct
        transform_keys(&:to_sym)

        # @see https://github.com/dry-rb/dry-struct/blob/release-1.6/lib/dry/struct/class_interface.rb#L249
        def self.new(*)
          super
        rescue Dry::Struct::Error => e
          raise InvalidArgumentError, e
        end
      end
    end
  end
end
