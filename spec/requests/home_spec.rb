require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("URL Shortener")
    end
  end

  describe "POST /shorten" do
    context "with valid attributes" do
      it "creates a new link and renders the result" do
        expect {
          post "/shorten", params: { link: { original_url: "https://example.com" } }
        }.to change(Link, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Short link created!")
        expect(response.body).to include(Link.last.short_url)
      end
    end

    context "with invalid attributes" do
      it "does not create a link and renders errors" do
        expect {
          post "/shorten", params: { link: { original_url: "invalid-url" } }
        }.not_to change(Link, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error creating link")
      end
    end
  end
end
