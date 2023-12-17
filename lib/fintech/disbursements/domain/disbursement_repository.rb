# frozen_string_literal: true

module Fintech
  module Disbursements
    module Domain
      module DisbursementRepository
        Interface = Types::Interface(:all, :create, :first_in_month_for_merchant?)
      end
    end
  end
end
