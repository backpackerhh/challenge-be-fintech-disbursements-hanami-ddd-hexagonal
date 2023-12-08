# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class Event
        attr_reader :aggregate_id, :aggregate_attributes, :occurred_at, :id, :name

        private_class_method :new

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id, SecureRandom.uuid),
              aggregate_id: attributes.fetch(:aggregate_id),
              aggregate_attributes: attributes.fetch(:aggregate_attributes),
              occurred_at: attributes.fetch(:occurred_at))
        end

        def initialize(id:, aggregate_id:, aggregate_attributes:, occurred_at:)
          @id = id
          @aggregate_id = aggregate_id
          @aggregate_attributes = aggregate_attributes
          @occurred_at = occurred_at
          @name = self.class.name
        end

        def to_primitives
          {
            id:,
            type: name,
            occurred_at: occurred_at.strftime("%Y-%m-%d %H:%M:%S.%N %z"),
            attributes: {
              id: aggregate_id,
              **aggregate_attributes
            }
          }
        end

        def ==(other)
          name == other.name &&
            occurred_at == other.occurred_at &&
            aggregate_id == other.aggregate_id &&
            aggregate_attributes == other.aggregate_attributes
        end
      end
    end
  end
end
