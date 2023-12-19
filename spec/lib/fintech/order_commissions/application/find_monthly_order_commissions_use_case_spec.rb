# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::OrderCommissions::Application::FindMonthlyOrderCommissionsUseCase, type: :use_case do
  describe "#sum_monthly_amount(merchant_id:, date:)" do
    let(:repository) { Fintech::OrderCommissions::Infrastructure::InMemoryOrderCommissionRepository.new }

    it "returns grouped disbursable merchants" do
      use_case = described_class.new(repository:)
      merchant_id = SecureRandom.uuid
      date = Date.parse("2023-04-02")

      allow(repository).to receive(:monthly_amount).with(merchant_id:, date:) { 123.45 }

      result = use_case.sum_monthly_amount(merchant_id:, date:)

      expect(result).to eq(123.45)
    end
  end
end
