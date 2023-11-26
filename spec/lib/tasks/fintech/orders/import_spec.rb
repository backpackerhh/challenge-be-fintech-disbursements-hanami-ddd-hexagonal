# frozen_string_literal: true

require "spec_helper"

RSpec.describe "fintech:orders:import", type: %i[task database] do
  include_context "rake"

  it "preloads the environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "aborts execution when no file path is given" do
    expect { task.invoke }.to output(/No file path given.+Example usage/m).to_stdout
  end

  it "aborts execution when given file is not supported" do
    expect { task.invoke("spec/support/data/orders.xls") }.to output(/Supported files.+Example usage/m).to_stdout
  end

  it "aborts execution when given file does not exist" do
    expect { task.invoke("spec/support/data/fake.csv") }.to output(/not found.+Example usage/m).to_stdout
  end

  it "imports orders from given file", :sidekiq_inline do
    orders = Fintech::Container["orders.repository"].all

    expect(orders.map(&:id)).to eq([])

    task.invoke("spec/support/data/orders.csv")

    orders = Fintech::Container["orders.repository"].all

    expect(orders.map { |m| m.id.value }).to match_array(
      %w[
        0df9c70e-142f-4960-859f-30aa14f8e103
        92baa6b6-08f7-4ab9-b662-9ab866fce3ec
        1bc24c57-e778-4b7b-a636-5a34c4cebfb8
        cf7407fc-09fd-47f6-ad66-35c858ae7a1d
        aaf1108b-3aa9-4fe5-a05b-3c72ce8fcf59
        107511ee-b588-461e-966c-342cbcc20088
      ]
    )
  end
end
