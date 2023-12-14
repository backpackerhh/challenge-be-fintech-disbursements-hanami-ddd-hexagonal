# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      module MerchantRepository
        Interface = Types::Interface(:all, :find_by_id, :grouped_disbursable_ids, :create)
      end
    end
  end
end
