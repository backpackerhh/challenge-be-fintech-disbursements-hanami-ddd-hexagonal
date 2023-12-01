# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Domain
      class OrderCommissionCreatedAtFactory
        def self.build(value = Time.now)
          value
        end
      end
    end
  end
end
