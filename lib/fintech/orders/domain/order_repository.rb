# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      module OrderRepository
        Interface = Types::Interface(:all, :create, :find_by_id)
      end
    end
  end
end
