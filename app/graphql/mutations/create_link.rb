# frozen_string_literal: true

module Mutations
  # Mutation to create a new short link.
  class CreateLink < BaseMutation
    argument :original_url, String, required: true, description: "The original URL to be shortened"

    field :link, Types::LinkType, null: true, description: "The created link object"
    field :errors, [ String ], null: false, description: "A list of error messages if creation failed"

    # Resolves the mutation to create a link.
    #
    # @param original_url [String] The original URL to shorten
    # @return [Hash] A hash containing the created link and any errors
    def resolve(original_url:)
      link = Link.new(original_url: original_url)
      if link.save
        { link: link, errors: [] }
      else
        { link: nil, errors: link.errors.full_messages }
      end
    end
  end
end
