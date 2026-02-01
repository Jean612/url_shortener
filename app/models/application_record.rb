# Base class for all models in the application.
# Inherits from ActiveRecord::Base and is marked as the primary abstract class.
# This class serves as a central point for shared configuration and logic across all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
