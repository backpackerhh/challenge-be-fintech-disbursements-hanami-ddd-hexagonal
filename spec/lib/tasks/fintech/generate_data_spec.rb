# frozen_string_literal: true

require "spec_helper"

RSpec.describe "fintech:generate_data", type: %i[task database] do
  include_context "rake"

  it "preloads the environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "aborts execution when any exception is raised" do
    allow(Fintech::Container["merchants.repository"]).to receive(:all).and_raise(StandardError, "whatever")

    expect { task.invoke }.to output(/whatever.+Example usage/m).to_stdout
  end

  it "starts process to generates data" do
    merchant_a = Fintech::Merchants::Domain::MerchantEntityFactory.create(:weekly_disbursement)
    merchant_b = Fintech::Merchants::Domain::MerchantEntityFactory.create(:daily_disbursement)
    merchant_c = Fintech::Merchants::Domain::MerchantEntityFactory.create(:daily_disbursement)

    expect(Fintech::Container["orders.group_disbursable.job"]).to receive(:perform_async)
      .with(merchant_a.disbursement_frequency.value.downcase, merchant_a.id.value)
    expect(Fintech::Container["orders.group_disbursable.job"]).to receive(:perform_async)
      .with(merchant_b.disbursement_frequency.value.downcase, merchant_b.id.value)
    expect(Fintech::Container["orders.group_disbursable.job"]).to receive(:perform_async)
      .with(merchant_c.disbursement_frequency.value.downcase, merchant_c.id.value)

    task.invoke
  end
end
