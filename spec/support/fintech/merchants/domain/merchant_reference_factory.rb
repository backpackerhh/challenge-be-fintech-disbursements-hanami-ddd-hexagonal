# frozen_string_literal: true

module Fintech
  module Merchants
    module Domain
      class MerchantReferenceFactory
        def self.build(value = Faker::Internet.unique.username)
          value
        end
      end
    end
  end
end
