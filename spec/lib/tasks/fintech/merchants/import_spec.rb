# frozen_string_literal: true

require "spec_helper"

RSpec.describe "fintech:merchants:import", type: :task do
  include_context "rake"

  it "preloads the environment" do
    expect(task.prerequisites).to include "environment"
  end
end
