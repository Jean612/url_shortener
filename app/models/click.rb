# Represents a click on a shortened link.
# Stores information about the click, such as the IP address, user agent, and country.
class Click < ApplicationRecord
  # @!attribute link
  #   @return [Link] the link that was clicked
  belongs_to :link, counter_cache: true

  # @!attribute ip_address
  #   @return [String] the IP address of the requester
  validates :ip_address, presence: true

  # @!attribute user_agent
  #   @return [String, nil] the user agent string of the requester

  # @!attribute country
  #   @return [String, nil] the country code or name derived from the IP address

  # @!attribute created_at
  #   @return [DateTime] the timestamp when the click was recorded

  # @!attribute updated_at
  #   @return [DateTime] the timestamp when the record was last updated
end
