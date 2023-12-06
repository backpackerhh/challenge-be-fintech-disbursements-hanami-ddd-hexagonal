# frozen_string_literal: true

require "spec_helper"

RSpec.describe Fintech::Shared::Infrastructure::PublishEventJob, type: :job do
  it "has expected configuration" do
    expect(described_class.sidekiq_options.transform_keys(&:to_sym)).to eq(
      {
        queue: "domain_events",
        unique: true,
        retry: true,
        retry_for: 3600
      }
    )
  end
end
