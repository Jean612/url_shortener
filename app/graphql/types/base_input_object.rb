# frozen_string_literal: true

module Types
  # Base class for all GraphQL input objects.
  # Inherits from GraphQL::Schema::InputObject and provides common configuration for input objects.
  # Input objects are used as arguments for mutations and fields.
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
end
