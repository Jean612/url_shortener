FactoryBot.define do
  factory :link do
    original_url { "https://example.com" }
    slug { SecureRandom.alphanumeric(6) }
  end
end
