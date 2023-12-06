# frozen_string_literal: true

require "spec_helper"

RSpec.describe "fintech:merchants:import", type: %i[task database] do
  include_context "rake"

  it "preloads the environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "aborts execution when no file path is given" do
    expect { task.invoke }.to output(/No file path given.+Example usage/m).to_stdout
  end

  it "aborts execution when given file is not supported" do
    expect { task.invoke("spec/support/data/merchants.xls") }.to output(/Supported files.+Example usage/m).to_stdout
  end

  it "aborts execution when given file does not exist" do
    expect { task.invoke("spec/support/data/fake.csv") }.to output(/not found.+Example usage/m).to_stdout
  end

  it "imports merchants from given file", :sidekiq_inline, fake_event_bus: "domain_events.bus" do
    merchants = Fintech::Container["merchants.repository"].all

    expect(merchants.map(&:id)).to eq([])

    task.invoke("spec/support/data/merchants.csv")

    merchants = Fintech::Container["merchants.repository"].all

    expect(merchants.map { |m| m.id.value }).to match_array(
      %w[
        86312006-4d7e-45c4-9c28-788f4aa68a62
        d1649242-a612-46ba-82d8-225542bb9576
        a616488f-c8b2-45dd-b29f-364d12a20238
        9b6d2b8a-f06c-4298-8f27-f33545eb5899
      ]
    )
  end
end
