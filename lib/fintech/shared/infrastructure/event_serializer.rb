# frozen_string_literal: true

require "json-schema"

module Fintech
  module Shared
    module Infrastructure
      class EventSerializer
        def self.serialize(event)
          uuid_regex_pattern = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
          time_regex_pattern = /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{9} \+\d{4}\z/
          schema = {
            id: "domain-events-serializer",
            type: "object",
            required: %w[id type occurred_at attributes],
            properties: {
              id: { type: "string", pattern: uuid_regex_pattern },
              type: { type: "string" },
              occurred_at: { type: "string", pattern: time_regex_pattern },
              attributes: {
                type: "object",
                required: ["id"],
                properties: {
                  id: { type: "string", pattern: uuid_regex_pattern }
                }
              }
            }
          }

          validation_errors = JSON::Validator.fully_validate(schema, event.to_primitives)

          if validation_errors.any?
            raise Domain::InvalidEventSchemaError, validation_errors
          end

          JSON.parse({ data: { **event.to_primitives } }.to_json)
        end

        def self.deserialize(raw_event)
          event_klass = Object.const_get(raw_event.dig("data", "type"))

          event_klass.from_primitives(
            aggregate_id: raw_event.dig("data", "attributes", "id"),
            aggregate_attributes: raw_event.dig("data", "attributes").except("id").transform_keys(&:to_sym),
            occurred_at: Time.parse(raw_event.dig("data", "occurred_at")),
            id: raw_event.dig("data", "id")
          )
        end
      end
    end
  end
end
