# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantEmailFactory
        def self.build(value = Faker::Internet.email)
          value
        end
      end
    end
  end
end
