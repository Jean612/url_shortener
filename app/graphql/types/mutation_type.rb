# frozen_string_literal: true

module Types
  # The root type for all GraphQL mutations.
  class MutationType < Types::BaseObject
    field :create_link, mutation: Mutations::CreateLink
  end
end
