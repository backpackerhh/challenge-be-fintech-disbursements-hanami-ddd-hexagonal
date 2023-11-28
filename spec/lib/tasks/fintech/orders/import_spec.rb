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
    merchant_a = Fintech::Merchants::Domain::MerchantEntityFactory.create(reference: "padberg_group")
    merchant_b = Fintech::Merchants::Domain::MerchantEntityFactory.create(reference: "deckow_gibson")
    merchant_c = Fintech::Merchants::Domain::MerchantEntityFactory.create(reference: "romaguera_and_sons")

    orders = Fintech::Container["orders.repository"].all

    expect(orders.map(&:id)).to eq([])

    task.invoke("spec/support/data/orders.csv")

    orders = Fintech::Container["orders.repository"].all

    expect(orders.map { |o| [o.merchant_id.value, o.amount.value] }).to match_array(
      [
        [merchant_a.id.value, BigDecimal("102.29")],
        [merchant_a.id.value, BigDecimal("433.21")],
        [merchant_b.id.value, BigDecimal("377.65")],
        [merchant_b.id.value, BigDecimal("138.49")],
        [merchant_b.id.value, BigDecimal("213.3")],
        [merchant_c.id.value, BigDecimal("462.34")]
      ]
    )
  end
end
