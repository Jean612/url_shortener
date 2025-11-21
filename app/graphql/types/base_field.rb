# frozen_string_literal: true

module Types
  # Base class for all GraphQL fields.
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument
  end
end
