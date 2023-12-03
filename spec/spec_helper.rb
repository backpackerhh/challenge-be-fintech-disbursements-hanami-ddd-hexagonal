# frozen_string_literal: true

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"
require "hanami/prepare"

require_relative "support/rspec"
require_relative "support/requests"
require_relative "support/database_cleaner"
require_relative "support/factory"
require_relative "support/sidekiq"
require_relative "support/timecop"
require_relative "support/shared_contexts/rake"

Dir["#{__dir__}/support/fintech/**/*.rb"].each { |file| require file }
