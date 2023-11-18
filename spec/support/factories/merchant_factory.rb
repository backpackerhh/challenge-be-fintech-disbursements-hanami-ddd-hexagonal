# frozen_string_literal: true

Factory.define(:merchant) do |f|
  f.id { SecureRandom.uuid }
  f.reference { Faker::Internet.unique.username }
end
