# Background job to record analytics for a link click.
# Performs Geocoding to determine country from IP address.
class ClickRecordingJob < ApplicationJob
  queue_as :default

  # Performs the click recording.
  #
  # @param link_id [Integer] The ID of the Link
  # @param ip_address [String] The IP address of the user
  # @param user_agent [String] The User Agent string
  # @return [void]
  def perform(link_id:, ip_address:, user_agent:)
    link = Link.find_by(id: link_id)
    return unless link

    country = begin
      Rails.cache.fetch("ip_country:#{ip_address}", expires_in: 24.hours) do
        Geocoder.search(ip_address).first&.country
      end
    rescue => e
      Rails.logger.error "Geocoder error: #{e.message}"
      nil
    end

    Click.create(
      link: link,
      ip_address: ip_address,
      user_agent: user_agent,
      country: country
    )
  end
end
