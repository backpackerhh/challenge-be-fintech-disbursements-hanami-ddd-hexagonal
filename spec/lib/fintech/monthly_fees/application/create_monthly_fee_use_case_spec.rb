# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::MonthlyFees::Application::CreateMonthlyFeeUseCase, type: :use_case do
  describe "#create(attributes)" do
    let(:repository) { Fintech::MonthlyFees::Infrastructure::InMemoryMonthlyFeeRepository.new }
    let(:event_bus) { Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new }
    let(:finder_service) { Fintech::Merchants::Domain::FakeFindMerchantService.new }
    let(:attributes) do
      {
        "id" => "0df9c70e-142f-4960-859f-30aa14f8e103",
        "merchant_id" => "86312006-4d7e-45c4-9c28-788f4aa68a62",
        "amount" => "10.29",
        "commissions_amount" => "4.71",
        "month" => "2023-04",
        "created_at" => "2023-04-01 07:00:01"
      }
    end

    it "raises an exception when merchant is not found" do
      allow(finder_service).to receive(:find).and_raise(Fintech::Merchants::Domain::MerchantNotFoundError)

      use_case = described_class.new(repository:, event_bus:, finder_service:)

      expect do
        use_case.create(attributes)
      end.to raise_error(Fintech::Merchants::Domain::MerchantNotFoundError)
    end

    context "with valid attributes" do
      it "creates monthly fee" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect(repository).to receive(:create).with(
          {
            id: "0df9c70e-142f-4960-859f-30aa14f8e103",
            merchant_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            amount: 10.29,
            commissions_amount: 4.71,
            month: "2023-04",
            created_at: Time.parse("2023-04-01 07:00:01")
          }
        )

        use_case.create(attributes)
      end

      it "publishes event about monthly fee created" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect(event_bus).to receive(:publish).with(
          Fintech::MonthlyFees::Domain::MonthlyFeeCreatedEventFactory.build(
            aggregate_id: "0df9c70e-142f-4960-859f-30aa14f8e103",
            aggregate_attributes: {
              merchant_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
              amount: BigDecimal("10.29"),
              commissions_amount: BigDecimal("4.71"),
              month: "2023-04"
            },
            occurred_at: Time.parse("2023-04-01 07:00:01")
          )
        )

        use_case.create(attributes)
      end
    end

    context "with invalid attributes" do
      it "does not create monthly fee (invalid ID)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create monthly fee (invalid merchant ID)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("merchant_id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create monthly fee (invalid amount)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create monthly fee (invalid commissions amount)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("commissions_amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create monthly fee (invalid month)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("month" => "2023/04"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+format.+failed/)
      end

      it "does not create monthly fee (invalid created at time)" do
        use_case = described_class.new(repository:, event_bus:, finder_service:)

        expect do
          use_case.create(attributes.merge("created_at" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+time.+failed/)
      end
    end
  end
end
