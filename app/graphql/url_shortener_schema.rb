# frozen_string_literal: true

# The main GraphQL schema for the URL Shortener application.
# Defines the entry points for queries and mutations, as well as configuration for types and execution.
class UrlShortenerSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  #
  # @param err [StandardError] The error that occurred
  # @param context [Hash] The query context
  # @return [void]
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Resolves abstract types (unions and interfaces) to concrete object types.
  #
  # @param abstract_type [Class] The abstract type being resolved
  # @param obj [Object] The object being resolved
  # @param ctx [Hash] The query context
  # @return [Class] The concrete GraphQL object type
  # @raise [GraphQL::RequiredImplementationMissingError] if not implemented
  def self.resolve_type(abstract_type, obj, ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Limit the size of incoming queries:
  max_query_string_tokens(5000)

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Generates a unique ID for a given object.
  #
  # @param object [Object] The object to generate an ID for
  # @param type_definition [Class] The GraphQL type definition
  # @param query_ctx [Hash] The query context
  # @return [String] The unique ID
  def self.id_from_object(object, type_definition, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Finds an object by its unique ID.
  #
  # @param global_id [String] The unique ID
  # @param query_ctx [Hash] The query context
  # @return [Object] The found object
  def self.object_from_id(global_id, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
