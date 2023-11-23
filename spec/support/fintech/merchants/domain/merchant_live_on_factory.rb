# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantLiveOnFactory
        def self.build(value = Date.today - 1)
          value
        end
      end
    end
  end
end
