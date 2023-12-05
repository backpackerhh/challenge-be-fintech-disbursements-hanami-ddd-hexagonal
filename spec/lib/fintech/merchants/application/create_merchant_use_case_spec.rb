# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Merchants::Application::CreateMerchantUseCase, type: :use_case do
  describe "#create(attributes)" do
    let(:repository) { Fintech::Merchants::Infrastructure::InMemoryMerchantRepository.new }
    let(:event_bus) { Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new }
    let(:attributes) do
      {
        "id" => "86312006-4d7e-45c4-9c28-788f4aa68a62",
        "reference" => "padberg_group",
        "email" => "info@padberg-group.com",
        "live_on" => "2023-02-01",
        "disbursement_frequency" => "DAILY",
        "minimum_monthly_fee" => "0.0"
      }
    end

    context "with valid attributes" do
      it "create merchant", :freeze_time do
        use_case = described_class.new(repository:, event_bus:)

        expect(repository).to receive(:create).with(
          {
            id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            reference: "padberg_group",
            email: "info@padberg-group.com",
            live_on: Date.parse("2023-02-01"),
            disbursement_frequency: "DAILY",
            minimum_monthly_fee: 0.0,
            created_at: Time.now
          }
        )

        use_case.create(attributes)
      end

      it "publishes event about merchant created", :freeze_time do
        use_case = described_class.new(repository:, event_bus:)

        expect(event_bus).to receive(:publish).with(
          Fintech::Merchants::Domain::MerchantCreatedEventFactory.build(
            aggregate_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            aggregate_attributes: {
              reference: "padberg_group",
              email: "info@padberg-group.com"
            },
            occurred_at: Time.now
          )
        )

        use_case.create(attributes)
      end
    end

    context "with invalid attributes" do
      it "does not create merchant (invalid ID)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create merchant (invalid email)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("email" => "email"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+format.+failed/)
      end

      it "does not create merchant (invalid live on date)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("live_on" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+date failed/)
      end

      it "does not create merchant (invalid disbursement frequency)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("disbursement_frequency" => "YEARLY"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+included_in.+failed/)
      end

      it "does not create merchant (invalid minimum monthly fee)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("minimum_monthly_fee" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create merchant (invalid created at time)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("created_at" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+time.+failed/)
      end
    end
  end
end
