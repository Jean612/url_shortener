# frozen_string_literal: true

module Mutations
  # Mutation to create a new short link.
  # This mutation accepts an original URL and returns the created Link object.
  class CreateLink < BaseMutation
    # @!attribute [r] original_url
    #   @return [String] The original URL to be shortened (required)
    argument :original_url, String, required: true

    # @!attribute [r] link
    #   @return [Types::LinkType, nil] The created link object
    field :link, Types::LinkType, null: true

    # @!attribute [r] errors
    #   @return [Array<String>] A list of error messages if the creation failed
    field :errors, [String], null: false

    # Resolves the mutation to create a link.
    # It attempts to create a new Link record with the provided original URL.
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
