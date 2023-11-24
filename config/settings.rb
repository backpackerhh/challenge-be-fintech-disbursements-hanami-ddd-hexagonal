# frozen_string_literal: true

module Fintech
  class Settings < Hanami::Settings
    setting :database_url, constructor: Types::Params::String
    setting :redis_url, constructor: Types::Params::String
  end
end
