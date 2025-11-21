# frozen_string_literal: true

module Types
  # The root type for all GraphQL mutations.
  class MutationType < Types::BaseObject
    field :create_link, mutation: Mutations::CreateLink
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    # A test field to verify the schema.
    # @return [String] A static string "Hello World"
    def test_field
      "Hello World"
    end
  end
end
