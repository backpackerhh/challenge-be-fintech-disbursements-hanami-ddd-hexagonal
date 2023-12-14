# frozen_string_literal: true

module Fintech
  module Merchants
    module Infrastructure
      class InMemoryMerchantRepository
        def all; end

        def find_by_id(_id); end

        def grouped_disbursable_ids; end

        def create(_attributes); end
      end
    end
  end
end
