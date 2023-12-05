# frozen_string_literal: true

require "dry/system/stubs"

RSpec.configure do |config|
  config.around do |example|
    if example.metadata[:fake_event_bus]
      Fintech::Container.enable_stubs!
      Fintech::Container.finalize!

      original_event_bus = Fintech::Container["domain_events.bus"]

      Fintech::Container.stub("domain_events.bus", Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new)

      example.run

      Fintech::Container.stub("domain_events.bus", original_event_bus)
    else
      example.run
    end
  end
end
