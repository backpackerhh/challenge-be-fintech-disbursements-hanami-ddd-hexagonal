# frozen_string_literal: true

require "dry/system/stubs"

RSpec.configure do |config|
  config.around do |example|
    if example.metadata[:fake_event_bus]
      event_bus_key = example.metadata[:fake_event_bus]

      Fintech::Container.enable_stubs!
      Fintech::Container.finalize!

      original_event_bus = Fintech::Container[event_bus_key]

      Fintech::Container.stub(event_bus_key, Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new)

      example.run

      Fintech::Container.stub(event_bus_key, original_event_bus)
    else
      example.run
    end
  end
end
