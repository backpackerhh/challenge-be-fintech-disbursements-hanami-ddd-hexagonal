# frozen_string_literal: true

module Fintech
  module Shared
    module Domain
      class EventSubscriber
        def on(event)
          raise NotImplementedError, "Define what will the event subscriber do upon receiving an event in #on method"
        end

        def subscribed_to
          raise NotImplementedError, "Define the list of events in #subscribed_to method"
        end
      end
    end
  end
end
