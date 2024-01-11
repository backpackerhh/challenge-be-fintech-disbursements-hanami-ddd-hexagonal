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
          id == other.id
        end
      end
    end
  end
end
