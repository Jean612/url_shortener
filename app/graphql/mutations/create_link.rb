# frozen_string_literal: true

module Mutations
  # Mutation to create a new short link.
  class CreateLink < BaseMutation
    argument :original_url, String, required: true

    field :link, Types::LinkType, null: true
    field :errors, [ String ], null: false

    # Resolves the mutation to create a link.
    #
    # @param original_url [String] The original URL to shorten
    # @return [Hash] A hash containing the created link and any errors
    def resolve(original_url:)
      link = Link.new(original_url: original_url)

      retries = 0
      begin
        if link.save
          { link: link, errors: [] }
        else
          { link: nil, errors: link.errors.full_messages }
        end
      rescue ActiveRecord::RecordNotUnique
        if retries < 3
          retries += 1
          link.slug = nil # clear slug to trigger generation of a new one
          retry
        else
          { link: nil, errors: ["Failed to generate a unique slug after multiple attempts"] }
        end
      end
    end
  end
end
