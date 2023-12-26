# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class FindDisbursableMerchantsService < Shared::Domain::Service
        attribute :repository, Domain::MerchantRepository::Interface

        include Deps["merchants.repository"]

        def retrieve_grouped_ids
          repository.grouped_disbursable_ids
        end
      end
    end
  end
end
