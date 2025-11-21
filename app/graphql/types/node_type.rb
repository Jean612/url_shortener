# frozen_string_literal: true

module Types
  # Interface for objects that can be fetched by ID.
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
