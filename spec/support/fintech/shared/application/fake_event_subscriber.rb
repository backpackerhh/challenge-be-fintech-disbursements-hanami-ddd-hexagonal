# frozen_string_literal: true

module Fintech
  module Shared
    module Application
      class FakeEventSubscriber
        def on(event)
          puts "Received event #{event.id}"
        end

        def subscribed_to
          [Domain::FakeEvent]
        end
      end
    end
  end
end
