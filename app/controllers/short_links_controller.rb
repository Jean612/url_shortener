# Controller responsible for handling short link redirections.
class ShortLinksController < ApplicationController
  # Redirects a short link slug to its original URL.
  # Records the click analytics (IP, user agent, country) before redirecting.
  #
  # @route GET /:slug
  # @param slug [String] The unique identifier for the short link
  # @return [void] Redirects to the original URL or renders a 404 plain text response
  def show
    link = Link.find_by(slug: params[:slug])

    if link
      # Track click asynchronously
      record_click(link)
      redirect_to link.original_url, allow_other_host: true, status: :moved_permanently
    else
      render plain: "404 Not Found", status: :not_found
    end
  end

  private

  # Records a click for a given link.
  # Enqueues a background job to record the click and perform geocoding.
  #
  # @param link [Link] The link that was clicked
  # @return [void]
  def record_click(link)
    ClickRecordingJob.perform_later(
      link_id: link.id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end
end
