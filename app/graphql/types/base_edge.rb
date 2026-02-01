# frozen_string_literal: true

module Types
  # Base class for all GraphQL edges.
  # Inherits from Types::BaseObject and includes standard Relay edge behaviors.
  # This is used for pagination, wrapping nodes with a cursor.
  class BaseEdge < Types::BaseObject
    # add `node` and `cursor` fields, as well as `node_type(...)` override
    include GraphQL::Types::Relay::EdgeBehaviors
  end
end
