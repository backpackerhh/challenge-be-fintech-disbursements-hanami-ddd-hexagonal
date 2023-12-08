# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Application::FindOrderUseCase, type: :use_case do
  describe "#find(id)" do
    let(:repository) { Fintech::Orders::Infrastructure::InMemoryOrderRepository.new }

    context "with an existing order" do
      it "returns it" do
        order = Fintech::Orders::Domain::OrderEntityFactory.build
        use_case = described_class.new(repository:)

        allow(repository).to receive(:find_by_id).with(order.id.value).and_return(order)

        found_order = use_case.find(order.id.value)

        expect(found_order).to eq(order)
      end
    end

    context "with a non-existing order" do
      it "raises an exception" do
        use_case = described_class.new(repository:)

        allow(repository).to receive(:find_by_id).with("order_id")
                                                 .and_raise(Fintech::Orders::Domain::OrderNotFoundError)

        expect do
          use_case.find("order_id")
        end.to raise_error(Fintech::Orders::Domain::OrderNotFoundError)
      end
    end
  end
end
