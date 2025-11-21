class Link < ApplicationRecord
  has_many :clicks, dependent: :destroy

  validates :original_url, presence: true, format: URI::regexp(%w[http https])
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create
  before_validation :set_defaults, on: :create

  def short_url
    options = Rails.application.config.action_controller.default_url_options || {}
    host = options[:host] || 'localhost:3001'
    Rails.application.routes.url_helpers.short_link_url(slug, host: host)
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.alphanumeric(6)
    loop do
      break unless Link.exists?(slug: slug)
      self.slug = SecureRandom.alphanumeric(6)
    end
  end

  def set_defaults
    self.clicks_count ||= 0
  end
end
