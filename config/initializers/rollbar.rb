Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]

  config.environment = ENV["ROLLBAR_ENV"].presence || Rails.env

  config.code_version = ENV["GIT_SHA"]

  config.exception_level_filters.merge!(
    "ActionController::RoutingError" => "ignore"
  )

  if Rails.env.test?
    config.enabled = false
  end
end
