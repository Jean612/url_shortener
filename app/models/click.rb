# Represents a click on a shortened link.
# Stores information about the click, such as the IP address and user agent.
class Click < ApplicationRecord
  # @!attribute link
  #   @return [Link] the link that was clicked
  belongs_to :link, counter_cache: true

  # @!attribute ip_address
  #   @return [String] the IP address of the requester
  validates :ip_address, presence: true

  # @!attribute user_agent
  #   @return [String, nil] the User-Agent string of the requester
  #   (This attribute is inferred from the database schema)

  # @!attribute country
  #   @return [String, nil] the country code inferred from the IP address
  #   (This attribute is inferred from the database schema)

  # @!attribute created_at
  #   @return [Time] the timestamp when the click was recorded
  #   (This attribute is inferred from the database schema)

  # @!attribute updated_at
  #   @return [Time] the timestamp when the click record was last updated
  #   (This attribute is inferred from the database schema)
end
