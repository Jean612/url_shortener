# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :link, Types::LinkType, null: true do
      argument :slug, String, required: true
    end

    def link(slug:)
      Link.find_by(slug: slug)
    end

    field :top_links, [Types::LinkType], null: false do
      argument :limit, Integer, required: false, default_value: 10
    end

    def top_links(limit:)
      Link.order(clicks_count: :desc).limit(limit)
    end
  end
end
