# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantIdFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
