# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      module MerchantRepository
        Interface = Dry.Types.Interface(:all, :create, :bulk_create)
      end
    end
  end
end
