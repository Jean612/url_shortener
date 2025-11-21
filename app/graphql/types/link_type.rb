# frozen_string_literal: true

module Types
  # GraphQL type representing a Link.
  class LinkType < Types::BaseObject
    field :id, ID, null: false
    field :original_url, String, null: false
    field :slug, String, null: false
    field :short_url, String, null: true
    field :clicks_count, Integer, null: false
    field :clicks, [Types::ClickType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
