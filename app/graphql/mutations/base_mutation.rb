# frozen_string_literal: true

module Mutations
  # Base class for all mutations.
  # Inherits from GraphQL::Schema::RelayClassicMutation.
  # Provides the foundation for defining mutations with standard argument, field, and object classes.
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end
end
