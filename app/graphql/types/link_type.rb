# frozen_string_literal: true

module Types
  # GraphQL type representing a Link.
  class LinkType < Types::BaseObject
    implements Types::NodeType

    field :id, ID, null: false
    field :original_url, String, null: false
    field :slug, String, null: false
    field :short_url, String, null: true
    field :clicks_count, Integer, null: false
    field :clicks, Types::ClickType.connection_type, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # Fetches the clicks associated with this link.
    # Returns a paginated connection to avoid loading all clicks at once.
    def clicks
      object.clicks
    end
  end
end
