# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantRepository
        def all
          raise NotImplementedError
        end

        def create(attributes)
          raise NotImplementedError
        end

        def bulk_create(attributes)
          raise NotImplementedError
        end
      end
    end
  end
end
