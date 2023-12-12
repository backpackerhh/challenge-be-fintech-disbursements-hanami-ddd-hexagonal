# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class InMemoryOrderRepository
        def all; end

        def find_by_id(_id); end

        def create(_attributes); end

        def group(_grouping_type, _merchant_id); end
      end
    end
  end
end
