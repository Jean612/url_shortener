# frozen_string_literal: true

module Types
  # Base class for all GraphQL fields.
  # Inherits from GraphQL::Schema::Field and allows customization of field behavior.
  # This class is used as the default field class for BaseObject and BaseInterface.
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument
  end
end
