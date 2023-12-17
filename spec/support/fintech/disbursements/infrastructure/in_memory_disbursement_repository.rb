# frozen_string_literal: true

module Fintech
  module Disbursements
    module Infrastructure
      class InMemoryDisbursementRepository
        def all; end

        def create(_attributes); end

        def first_in_month_for_merchant?(*); end
      end
    end
  end
end
