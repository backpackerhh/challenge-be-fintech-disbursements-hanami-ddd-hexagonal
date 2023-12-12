# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Orders::Infrastructure::GroupDisbursableOrdersJob, type: :job do
  it "has expected configuration" do
    expect(described_class.sidekiq_options.transform_keys(&:to_sym)).to eq(
      {
        queue: "disbursements",
        unique: true,
        retry: true,
        retry_for: 3600
      }
    )
  end
end
