# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      module OrderCommissionRepository
        Interface = Types::Interface(:all, :create, :exists?)
      end
    end
  end
end
