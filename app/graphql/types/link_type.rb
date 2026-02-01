# frozen_string_literal: true

module Types
  # GraphQL type representing a Link.
  # Exposes details about a shortened link, including its original URL, slug, and statistics.
  class LinkType < Types::BaseObject
    # @!attribute [r] id
    #   @return [ID] The unique identifier of the link
    field :id, ID, null: false

    # @!attribute [r] original_url
    #   @return [String] The original long URL
    field :original_url, String, null: false

    # @!attribute [r] slug
    #   @return [String] The unique short code for the link
    field :slug, String, null: false

    # @!attribute [r] short_url
    #   @return [String, nil] The full shortened URL
    field :short_url, String, null: true

    # @!attribute [r] clicks_count
    #   @return [Integer] The total number of clicks this link has received
    field :clicks_count, Integer, null: false

    # @!attribute [r] clicks
    #   @return [Array<Types::ClickType>, nil] The list of click events associated with this link
    field :clicks, [Types::ClickType], null: true

    # @!attribute [r] created_at
    #   @return [GraphQL::Types::ISO8601DateTime] The timestamp when the link was created
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    # @!attribute [r] updated_at
    #   @return [GraphQL::Types::ISO8601DateTime] The timestamp when the link was last updated
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
