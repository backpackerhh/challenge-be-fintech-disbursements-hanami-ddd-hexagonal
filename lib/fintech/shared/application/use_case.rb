# frozen_string_literal: true

require "dry/struct"

module Fintech
  module Shared
    module Application
      class UseCase < Dry::Struct
        transform_keys(&:to_sym)

        # @see https://github.com/dry-rb/dry-struct/blob/release-1.6/lib/dry/struct/class_interface.rb#L249
        def self.new(*)
          super
        rescue Dry::Struct::Error => e
          raise InvalidDependencyInjectedError, e
        end

        def self.repository(dependency_key, type)
          attribute :repository, type # order matters here

          include Deps[repository: dependency_key]
        end

        def self.logger
          attribute :logger, Types::Instance(Dry::Logger::Dispatcher)

          include Deps["logger"]
        end

        def self.event_bus(dependency_key = "domain_events.bus")
          attribute :event_bus, Domain::EventBus::Interface

          include Deps[event_bus: dependency_key]
        end

        def self.finder_service(dependency_key)
          attribute :finder_service, Types::Instance(Domain::Service)

          include Deps[finder_service: dependency_key]
        end

        def initialize(*)
          super

          if !respond_to?(:repository)
            raise NotImplementedError,
                  "Define the repository interface for the use case with .repository class method"
          end
        end
      end
    end
  end
end
