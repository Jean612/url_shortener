# frozen_string_literal: true

module Types
  # GraphQL type representing a Click.
  class ClickType < Types::BaseObject
    implements Types::NodeType

    field :id, ID, null: false
    field :link_id, Integer, null: false
    field :ip_address, String, null: true
    field :country, String, null: true
    field :user_agent, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
