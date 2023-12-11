# frozen_string_literal: true

require "timecop"

RSpec.configure do |config|
  config.around do |example|
    if (time = example.metadata[:freeze_time])
      Timecop.freeze(time) { example.run }
    else
      example.run
    end
  end
end
