# frozen_string_literal: true

module Types
  # GraphQL type representing a Click.
  # Exposes details about a click event, such as location and time.
  class ClickType < Types::BaseObject
    # @!attribute [r] id
    #   @return [ID] The unique identifier of the click
    field :id, ID, null: false

    # @!attribute [r] link_id
    #   @return [Integer] The ID of the associated link
    field :link_id, Integer, null: false

    # @!attribute [r] ip_address
    #   @return [String, nil] The IP address of the user who clicked
    field :ip_address, String, null: true

    # @!attribute [r] country
    #   @return [String, nil] The country code of the user
    field :country, String, null: true

    # @!attribute [r] user_agent
    #   @return [String, nil] The user agent string of the user's browser
    field :user_agent, String, null: true

    # @!attribute [r] created_at
    #   @return [GraphQL::Types::ISO8601DateTime] The timestamp when the click occurred
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
