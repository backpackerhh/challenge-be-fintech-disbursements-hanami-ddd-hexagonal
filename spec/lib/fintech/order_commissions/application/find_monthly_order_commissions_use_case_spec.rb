# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::OrderCommissions::Application::FindMonthlyOrderCommissionsUseCase, type: :use_case do
  describe "#sum_monthly_amount(merchant_id:, beginning_of_month:)" do
    let(:repository) { Fintech::OrderCommissions::Infrastructure::InMemoryOrderCommissionRepository.new }

    it "returns grouped disbursable merchants" do
      use_case = described_class.new(repository:)
      merchant_id = SecureRandom.uuid
      beginning_of_month = Date.parse("2023-04-02")

      allow(repository).to receive(:monthly_amount).with(merchant_id:, beginning_of_month:) { 123.45 }

      result = use_case.sum_monthly_amount(merchant_id:, beginning_of_month:)

      expect(result).to eq(123.45)
    end
  end
end
