class ShortLinksController < ApplicationController
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
