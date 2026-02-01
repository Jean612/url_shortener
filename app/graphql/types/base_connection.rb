# frozen_string_literal: true

module Types
  # Base class for all GraphQL connections.
  # Inherits from Types::BaseObject and includes standard Relay connection behaviors.
  # This is used for pagination.
  class BaseConnection < Types::BaseObject
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors
  end
end
