# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class FindMerchantService < Shared::Domain::Service
        attribute :repository, Domain::MerchantRepository::Interface

        include Deps["merchants.repository"]

        def find(id)
          repository.find_by_id(id)
        end
      end
    end
  end
end
