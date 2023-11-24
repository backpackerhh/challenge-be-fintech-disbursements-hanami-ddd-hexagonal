# frozen_string_literal: true

require "sidekiq"

module Fintech
  module Shared
    module Infrastructure
      class Job
        def self.inherited(base)
          super
          base.include(Sidekiq::Job)
        end
      end
    end
  end
end
