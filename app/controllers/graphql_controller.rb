# frozen_string_literal: true

# Controller responsible for handling GraphQL queries and mutations.
# This is the single entry point for all GraphQL interactions.
class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  # Executes a GraphQL query or mutation.
  # It parses the incoming variables and query string, then executes them against the UrlShortenerSchema.
  #
  # @route POST /graphql
  # @param variables [String, Hash, ActionController::Parameters, nil] GraphQL variables provided in the request
  # @param query [String] The GraphQL query string to be executed
  # @param operationName [String, nil] The name of the specific operation to execute if multiple are present
  # @return [void] Renders the JSON result of the GraphQL execution or error details
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = UrlShortenerSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Prepares GraphQL variables from various input formats.
  # It handles variables passed as a JSON string, a Hash, or ActionController::Parameters.
  #
  # @param variables_param [String, Hash, ActionController::Parameters, nil] The raw variables parameter from the request
  # @return [Hash] The parsed and safe variables hash ready for GraphQL execution
  # @raise [ArgumentError] if the parameter type is unexpected
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  # Handles errors during development by logging them and returning a JSON error response.
  # This helps in debugging issues by providing the error message and backtrace in the response.
  #
  # @param e [StandardError] The exception that occurred
  # @return [void] Renders a JSON response with error details and a 500 status code
  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
