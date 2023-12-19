# frozen_string_literal: true

namespace :fintech do
  desc "[OTT] Generate disbursements and monthly fees"
  task generate_data: :environment do
    merchants = Fintech::Container["merchants.repository"].all
    merchants.each do |merchant|
      Fintech::Container["orders.group_disbursable.job"].perform_async(
        merchant.disbursement_frequency.value.downcase,
        merchant.id.value
      )
    end

    Hanami.logger.info("Job enqueued to generate missing disbursements and monthly fees")
  rescue StandardError => e
    puts e.inspect
    puts "Example usage: rake fintech:generate_data"
  end
end
