# Base class for all models in the application.
# Inherits from ActiveRecord::Base and is marked as the primary abstract class.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
