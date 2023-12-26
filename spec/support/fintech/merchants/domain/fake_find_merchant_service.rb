# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class FakeFindMerchantService < Shared::Domain::Service
        def find(_id); end
      end
    end
  end
end
