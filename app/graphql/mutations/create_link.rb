# frozen_string_literal: true

module Mutations
  class CreateLink < BaseMutation
    argument :original_url, String, required: true

    field :link, Types::LinkType, null: true
    field :errors, [String], null: false

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
