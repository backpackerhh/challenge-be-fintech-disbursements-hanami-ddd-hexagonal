# frozen_string_literal: true

module Fintech
  module Shared
    module Infrastructure
      module DatabaseExceptionHandler
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def method_added(method_name)
            super

            return if @_adding_method

            @_adding_method = true

            original_method_name = "#{method_name}_without_exception_handling".to_sym
            alias_method original_method_name, method_name

            define_method(method_name) do |*args, **kwargs, &block|
              send(original_method_name, *args, **kwargs, &block)
            rescue Sequel::DatabaseError => e
              raise DatabaseError, e # register in Honeybadger or similar platform...
            end

            @_adding_method = false
          end
        end
      end
    end
  end
end
