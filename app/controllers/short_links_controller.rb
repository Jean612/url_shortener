# Controller responsible for handling short link redirections.
class ShortLinksController < ApplicationController
  # Redirects a short link slug to its original URL.
  # Records the click analytics (IP, user agent, country) before redirecting.
  # If the slug is not found, it renders a 404 response.
  #
  # @route GET /s/:slug
  # @param slug [String] The unique identifier for the short link, passed as a path parameter
  # @return [void] Redirects to the original URL or renders a 404 plain text response
  def show
    link = Link.find_by(slug: params[:slug])

    if link
      # Async tracking could be better for performance, but synchronous is fine for MVP
      record_click(link)
      redirect_to link.original_url, allow_other_host: true, status: :moved_permanently
    else
      render plain: "404 Not Found", status: :not_found
    end
  end

  private

  # Records a click for a given link.
  # Attempts to determine the country from the IP address using Geocoder.
  #
  # @param link [Link] The link that was clicked
  # @return [Click] The created Click record
  def record_click(link)
    # Simple IP to Country lookup
    # In production, use a real database or service. Geocoder with default lookup might be slow or rate limited.
    # For this MVP, we'll try Geocoder but fail gracefully.
    country = begin
      Geocoder.search(request.remote_ip).first&.country
    rescue => e
      Rails.logger.error "Geocoder error: #{e.message}"
      nil
    end

    Click.create(
      link: link,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      country: country
    )
  end
end
