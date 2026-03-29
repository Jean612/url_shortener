require 'rails_helper'

RSpec.describe Mutations::CreateLink do
  describe 'resolve' do
    it 'rescues uniqueness collision and retries successfully' do
      create(:link, slug: "AAAAAA")

      # First attempt returns collision "AAAAAA", second returns "BBBBBB"
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return("AAAAAA", "BBBBBB")

      query = <<-GRAPHQL
        mutation {
          createLink(input: { originalUrl: "https://example.com/2" }) {
            link {
              slug
            }
            errors
          }
        }
      GRAPHQL

      result = UrlShortenerSchema.execute(query)

      data = result.to_h.dig("data", "createLink")
      expect(data["errors"]).to be_empty
      expect(data.dig("link", "slug")).to eq("BBBBBB")
    end

    it 'returns error after multiple collisions' do
      create(:link, slug: "AAAAAA")

      # All attempts return collision
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return("AAAAAA")

      query = <<-GRAPHQL
        mutation {
          createLink(input: { originalUrl: "https://example.com/2" }) {
            link {
              slug
            }
            errors
          }
        }
      GRAPHQL

      result = UrlShortenerSchema.execute(query)

      data = result.to_h.dig("data", "createLink")
      expect(data["link"]).to be_nil
      expect(data["errors"]).to include("Failed to generate a unique slug after multiple attempts")
    end
  end
end
