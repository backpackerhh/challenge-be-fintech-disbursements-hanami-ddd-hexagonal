# frozen_string_literal: true

module Fintech
  module Orders
    module Domain
      class FakeFindOrderService < Shared::Domain::Service
        def find(_id); end
      end
    end
  end
end
