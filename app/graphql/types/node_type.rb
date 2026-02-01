# frozen_string_literal: true

module Types
  # Interface for objects that can be fetched by ID.
  # Implements the Relay Node interface, allowing object identification and fetching.
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
