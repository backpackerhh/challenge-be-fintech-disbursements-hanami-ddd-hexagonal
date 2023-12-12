# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Disbursements::Application::CreateDisbursementUseCase, type: :use_case do
  describe "#create(attributes)" do
    let(:repository) { Fintech::Disbursements::Infrastructure::InMemoryDisbursementRepository.new }
    let(:event_bus) { Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new }
    let(:attributes) do
      {
        "id" => "93711b5b-0f08-49d9-b819-322d83801d09",
        "merchant_id" => "86312006-4d7e-45c4-9c28-788f4aa68a62",
        "reference" => "FegBgohOER0N",
        "amount" => "102.29",
        "commissions_amount" => "1.01",
        "order_ids" => %w[9dc5d490-e823-455b-a6b0-645b3f8aeee3 2d32fd3f-e149-44d1-b0bc-176e28241f78],
        "start_date" => "2023-01-31",
        "end_date" => "2023-01-31",
        "created_at" => "2023-02-01"
      }
    end

    context "with valid attributes" do
      it "creates disbursement" do
        use_case = described_class.new(repository:, event_bus:)

        expect(repository).to receive(:create).with(
          {
            id: "93711b5b-0f08-49d9-b819-322d83801d09",
            reference: "FegBgohOER0N",
            merchant_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            amount: 102.29,
            commissions_amount: 1.01,
            order_ids: %w[9dc5d490-e823-455b-a6b0-645b3f8aeee3 2d32fd3f-e149-44d1-b0bc-176e28241f78],
            start_date: Date.parse("2023-01-31"),
            end_date: Date.parse("2023-01-31"),
            created_at: Time.parse("2023-02-01")
          }
        )

        use_case.create(attributes)
      end

      it "publishes event about disbursement created" do
        use_case = described_class.new(repository:, event_bus:)

        expect(event_bus).to receive(:publish).with(
          Fintech::Disbursements::Domain::DisbursementCreatedEventFactory.build(
            aggregate_id: "93711b5b-0f08-49d9-b819-322d83801d09",
            aggregate_attributes: {
              merchant_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
              reference: "FegBgohOER0N",
              amount: BigDecimal("102.29"),
              order_ids: %w[9dc5d490-e823-455b-a6b0-645b3f8aeee3 2d32fd3f-e149-44d1-b0bc-176e28241f78]
            },
            occurred_at: Time.parse("2023-02-01")
          )
        )

        use_case.create(attributes)
      end
    end

    context "with invalid attributes" do
      it "does not create disbursement (invalid ID)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create disbursement (invalid merchant ID)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("merchant_id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create disbursement (invalid amount)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create disbursement (invalid commissions amount)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("commissions_amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create disbursement (invalid order IDs)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("order_ids" => [1, 2]))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /Array.+invalid type.+uuid_v4.+failed/)
      end

      it "does not create disbursement (invalid start date)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("start_date" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+date failed/)
      end

      it "does not create disbursement (invalid end date)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("end_date" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+date failed/)
      end

      it "does not create disbursement (invalid created at time)" do
        use_case = described_class.new(repository:, event_bus:)

        expect do
          use_case.create(attributes.merge("created_at" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+time.+failed/)
      end
    end
  end
end
