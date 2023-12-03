# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class Event
        attr_reader :id, :name, :occurred_at, :attributes

        def initialize(name:, occurred_at:, attributes:)
          @id = SecureRandom.uuid
          @name = name
          @occurred_at = occurred_at
          @attributes = attributes
        end
      end
    end
  end
end
