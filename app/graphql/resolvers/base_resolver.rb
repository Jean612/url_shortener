# frozen_string_literal: true

module Resolvers
  # Base class for all GraphQL resolvers.
  # Inherits from GraphQL::Schema::Resolver.
  # Resolvers are used to isolate complex logic for fetching fields.
  class BaseResolver < GraphQL::Schema::Resolver
  end
end
