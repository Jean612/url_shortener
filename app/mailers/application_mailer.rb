# Base class for all mailers in the application.
# Inherits from ActionMailer::Base and provides common configuration and layout for emails.
# All mailers in this application should inherit from this class.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
