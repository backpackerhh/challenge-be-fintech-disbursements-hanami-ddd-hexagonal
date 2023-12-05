# frozen_string_literal: true

module Fintech
  module Shared
    module Infrastructure
      class FakeInMemoryEventBus
        def publish(_event); end
      end
    end
  end
end
