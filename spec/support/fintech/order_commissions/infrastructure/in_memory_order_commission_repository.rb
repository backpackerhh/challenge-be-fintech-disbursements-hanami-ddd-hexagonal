# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Infrastructure
      class InMemoryOrderCommissionRepository
        def all; end

        def create(_attributes); end

        def exists?(_attributes); end

        def monthly_amount(*); end
      end
    end
  end
end
