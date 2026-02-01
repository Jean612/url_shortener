# frozen_string_literal: true

module Types
  # Base class for all GraphQL objects.
  # Inherits from GraphQL::Schema::Object and provides common configuration.
  # Custom object types should inherit from this class.
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField
  end
end
