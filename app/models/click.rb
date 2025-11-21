# Represents a click on a shortened link.
# Stores information about the click, such as the IP address and user agent.
class Click < ApplicationRecord
  # @!attribute link
  #   @return [Link] the link that was clicked
  belongs_to :link, counter_cache: true

  # @!attribute ip_address
  #   @return [String] the IP address of the requester
  validates :ip_address, presence: true
end
