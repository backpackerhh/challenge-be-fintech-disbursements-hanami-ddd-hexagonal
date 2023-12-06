# frozen_string_literal: true

module Fintech
  module Shared
    module Infrastructure
      class PublishEventJob < Job
        sidekiq_options queue: "domain_events", unique: true, retry_for: 3600 # 1 hour

        def perform(subscriber_klass_name, raw_event)
          event = EventSerializer.deserialize(raw_event)

          Object.const_get(subscriber_klass_name).new.on(event)

          logger.info("Job enqueued to publish event #{event.id}")
        end
      end
    end
  end
end
