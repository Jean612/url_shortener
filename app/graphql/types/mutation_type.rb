# frozen_string_literal: true

module Types
  # The root type for all GraphQL mutations.
  # This type exposes all available mutation operations in the API.
  class MutationType < Types::BaseObject
    # @!attribute [r] create_link
    #   @return [Mutations::CreateLink] Mutation to create a new short link
    field :create_link, mutation: Mutations::CreateLink

    # TODO: remove me
    # @!attribute [r] test_field
    #   @return [String] An example field
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    # A test field to verify the schema.
    # @return [String] A static string "Hello World"
    def test_field
      "Hello World"
    end
  end
end
