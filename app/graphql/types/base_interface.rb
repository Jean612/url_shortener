# frozen_string_literal: true

module Types
  # Base module for all GraphQL interfaces.
  # Includes GraphQL::Schema::Interface and provides common configuration for interfaces.
  # Custom interfaces should include this module.
  module BaseInterface
    include GraphQL::Schema::Interface
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)

    field_class Types::BaseField
  end
end
