# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantCreatedAtFactory
        def self.build(value = Time.now)
          value
        end
      end
    end
  end
end
