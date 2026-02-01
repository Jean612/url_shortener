# frozen_string_literal: true

module Types
  # The root type for all GraphQL queries.
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    # Fetches an object by its global ID.
    #
    # @param id [ID] The global ID of the object
    # @return [Object, nil] The object found, or nil
    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    # Fetches a list of objects by their global IDs.
    #
    # @param ids [Array<ID>] The list of global IDs
    # @return [Array<Object, nil>] The list of objects found
    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :link, Types::LinkType, null: true, description: "Fetches a specific link by its slug" do
      argument :slug, String, required: true, description: "The unique slug of the link"
    end

    # Fetches a link by its slug.
    #
    # @param slug [String] The slug of the link
    # @return [Link, nil] The link found, or nil
    def link(slug:)
      Link.find_by(slug: slug)
    end

    field :top_links, [ Types::LinkType ], null: false, description: "Fetches the most visited links" do
      argument :limit, Integer, required: false, default_value: 10, description: "The maximum number of links to return"
    end

    # Fetches the top links by click count.
    #
    # @param limit [Integer] The maximum number of links to return (default: 10)
    # @return [ActiveRecord::Relation<Link>] The list of top links
    def top_links(limit:)
      Link.order(clicks_count: :desc).limit(limit)
    end
  end
end
