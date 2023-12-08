# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class AggregateRoot
        private_class_method :new

        def to_primitives
          raise NotImplementedError, "Define #to_primitives method"
        end

        def ==(other)
          to_primitives == other.to_primitives
        end
      end
    end
  end
end
