# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.0"
gem "hanami-controller", "~> 2.0"
gem "hanami-router", "~> 2.0"
gem "hanami-validations", "~> 2.0"

gem "pg", "~> 1.5"
gem "rom", "~> 5.3"
gem "rom-sql", "~> 3.6"

gem "dry-types", "~> 1.0", ">= 1.6.1"
gem "puma"
gem "rake"

group :development, :test do
  gem "debug"
  gem "dotenv"
end

group :cli, :development do
  gem "hanami-reloader"
end

group :cli, :development, :test do
  gem "hanami-rspec"
  gem "rubocop", "~> 1.57", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "guard-puma", "~> 0.8"
end

group :test do
  gem "database_cleaner-sequel"
  gem "rack-test"
end
