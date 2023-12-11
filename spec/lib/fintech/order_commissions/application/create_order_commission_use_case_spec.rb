# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::OrderCommissions::Application::CreateOrderCommissionUseCase, type: :use_case do
  describe "#create(attributes)" do
    let(:repository) { Fintech::OrderCommissions::Infrastructure::InMemoryOrderCommissionRepository.new }
    let(:event_bus) { Fintech::Shared::Infrastructure::FakeInMemoryEventBus.new }
    let(:finder_use_case) { Fintech::Orders::Application::FakeFindOrderUseCase.new }
    let(:attributes) do
      {
        "id" => "d1649242-a612-46ba-82d8-225542bb9576",
        "order_id" => "86312006-4d7e-45c4-9c28-788f4aa68a62",
        "order_amount" => BigDecimal("299.99")
      }
    end

    it "raises an exception when order is not found" do
      allow(finder_use_case).to receive(:find).and_raise(Fintech::Orders::Domain::OrderNotFoundError)

      use_case = described_class.new(repository:, event_bus:, finder_use_case:)

      expect do
        use_case.create(attributes)
      end.to raise_error(Fintech::Orders::Domain::OrderNotFoundError)
    end

    it "raises an exception when order already has a commission associated" do
      allow(repository).to receive(:exists?).with(order_id: "86312006-4d7e-45c4-9c28-788f4aa68a62") { true }

      use_case = described_class.new(repository:, event_bus:, finder_use_case:)

      expect do
        use_case.create(attributes)
      end.to raise_error(Fintech::OrderCommissions::Domain::AlreadyExistingOrderCommissionError)
    end

    context "with valid attributes", freeze_time: Time.now do
      it "creates order commission with tier 1 fee" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect(repository).to receive(:create).with(
          {
            id: "d1649242-a612-46ba-82d8-225542bb9576",
            order_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            order_amount: BigDecimal("49.99"),
            amount: BigDecimal("0.5"),
            fee: BigDecimal("1.0"),
            created_at: Time.now
          }
        )

        use_case.create(attributes.merge(order_amount: BigDecimal("49.99")))
      end

      it "creates order commission with tier 2 fee" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect(repository).to receive(:create).with(
          {
            id: "d1649242-a612-46ba-82d8-225542bb9576",
            order_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            order_amount: BigDecimal("299.99"),
            amount: BigDecimal("2.85"),
            fee: BigDecimal("0.95"),
            created_at: Time.now
          }
        )

        use_case.create(attributes.merge(order_amount: BigDecimal("299.99")))
      end

      it "creates order commission with tier 3 fee" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect(repository).to receive(:create).with(
          {
            id: "d1649242-a612-46ba-82d8-225542bb9576",
            order_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
            order_amount: BigDecimal("300.00"),
            amount: BigDecimal("2.55"),
            fee: BigDecimal("0.85"),
            created_at: Time.now
          }
        )

        use_case.create(attributes.merge(order_amount: BigDecimal("300.00")))
      end

      it "publishes event about order commission created" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect(event_bus).to receive(:publish).with(
          Fintech::OrderCommissions::Domain::OrderCommissionCreatedEventFactory.build(
            aggregate_id: "d1649242-a612-46ba-82d8-225542bb9576",
            aggregate_attributes: {
              order_id: "86312006-4d7e-45c4-9c28-788f4aa68a62",
              order_amount: BigDecimal("300.00"),
              amount: BigDecimal("2.55")
            },
            occurred_at: Time.now
          )
        )

        use_case.create(attributes.merge(order_amount: BigDecimal("300.00")))
      end
    end

    context "with invalid attributes" do
      it "does not create order commission (invalid ID)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create order commission (invalid order ID)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("order_id" => "uuid"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+uuid_v4.+failed/)
      end

      it "does not create order commission (invalid order amount)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("order_amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create order commission (invalid amount)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("amount" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create order commission (invalid fee)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("fee" => "free"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+coerced to decimal.+failed/)
      end

      it "does not create order commission (invalid created at time)" do
        use_case = described_class.new(repository:, event_bus:, finder_use_case:)

        expect do
          use_case.create(attributes.merge("created_at" => "yesterday"))
        end.to raise_error(Fintech::Shared::Domain::InvalidArgumentError, /invalid type.+time.+failed/)
      end
    end
  end
end
