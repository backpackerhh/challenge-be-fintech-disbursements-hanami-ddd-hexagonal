# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class ListMerchantsService < Shared::Domain::Service
        attribute :repository, Domain::MerchantRepository::Interface

        include Deps["merchants.repository"]

        def retrieve_all
          repository.all
        end
      end
    end
  end
end
