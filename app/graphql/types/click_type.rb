# frozen_string_literal: true

module Types
  # GraphQL type representing a Click.
  # Exposes details about a specific visit to a shortened link.
  class ClickType < Types::BaseObject
    field :id, ID, null: false, description: "The unique identifier of the click"
    field :link_id, Integer, null: false, description: "The ID of the associated link"
    field :ip_address, String, null: true, description: "The IP address of the visitor"
    field :country, String, null: true, description: "The country of the visitor derived from IP"
    field :user_agent, String, null: true, description: "The user agent string of the visitor"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "The timestamp when the click occurred"
  end
end
