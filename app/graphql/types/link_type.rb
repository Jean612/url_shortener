# frozen_string_literal: true

module Types
  # GraphQL type representing a Link.
  # Exposes details about a shortened URL and its associated analytics.
  class LinkType < Types::BaseObject
    field :id, ID, null: false, description: "The unique identifier of the link"
    field :original_url, String, null: false, description: "The original long URL"
    field :slug, String, null: false, description: "The unique short code for the link"
    field :short_url, String, null: true, description: "The full shortened URL"
    field :clicks_count, Integer, null: false, description: "The total number of times the link has been clicked"
    field :clicks, [ Types::ClickType ], null: true, description: "A list of individual clicks associated with this link"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The timestamp when the link was created"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The timestamp when the link was last updated"
  end
end
