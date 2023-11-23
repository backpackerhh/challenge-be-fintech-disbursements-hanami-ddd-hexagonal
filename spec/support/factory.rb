# frozen_string_literal: true

require "rom-factory"
require "faker"

Factory = ROM::Factory.configure do |config|
  config.rom = Fintech::App.container["persistence.rom"]
end

Dir["#{__dir__}/**/*_factory.rb"].each { |file| require file }
