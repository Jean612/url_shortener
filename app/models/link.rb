# Represents a shortened link.
# Stores the original URL, a unique slug, and tracks the click count.
class Link < ApplicationRecord
  # @!attribute clicks
  #   @return [ActiveRecord::Relation<Click>] the collection of clicks associated with this link
  has_many :clicks, dependent: :destroy

  # @!attribute original_url
  #   @return [String] the original long URL
  validates :original_url, presence: true, format: URI.regexp(%w[http https])

  # @!attribute slug
  #   @return [String] the unique identifier for the shortened link
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create
  before_validation :set_defaults, on: :create

  # Generates the full short URL for the link.
  # Uses the host configuration from default_url_options or defaults to localhost.
  #
  # @return [String] the full shortened URL (e.g., http://localhost:3001/s/abc123)
  def short_url
    options = Rails.application.config.action_controller.default_url_options || {}
    host = ENV["RENDER_EXTERNAL_HOSTNAME"] || options[:host] || "localhost:3000"
    Rails.application.routes.url_helpers.short_link_url(slug, host: host)
  end

  private

  # Generates a unique 6-character alphanumeric slug.
  # If a slug is not already provided, it generates one and ensures uniqueness.
  #
  # @return [void]
  def generate_slug
    self.slug ||= SecureRandom.alphanumeric(6)
    loop do
      break unless Link.exists?(slug: slug)
      self.slug = SecureRandom.alphanumeric(6)
    end
  end

  # Sets default values for new records.
  # Initializes clicks_count to 0.
  #
  # @return [void]
  def set_defaults
    self.clicks_count ||= 0
  end
end
