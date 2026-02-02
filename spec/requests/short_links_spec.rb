require 'rails_helper'

RSpec.describe "ShortLinks", type: :request do
  include ActiveJob::TestHelper

  describe "GET /:slug" do
    let!(:link) { create(:link, original_url: "https://example.com") }

    context "when the slug exists" do
      it "redirects to the original url" do
        get "/#{link.slug}"
        expect(response).to redirect_to(link.original_url)
      end

      it "increments the click count" do
        expect {
          perform_enqueued_jobs do
            get "/#{link.slug}"
          end
        }.to change { link.reload.clicks_count }.by(1)
      end

      it "creates a click record" do
        expect {
          perform_enqueued_jobs do
            get "/#{link.slug}"
          end
        }.to change(Click, :count).by(1)
      end

      it "records the ip address and user agent" do
        perform_enqueued_jobs do
          get "/#{link.slug}", headers: { "User-Agent" => "TestAgent" }
        end
        click = Click.last
        expect(click.link).to eq(link)
        expect(click.user_agent).to eq("TestAgent")
        expect(click.ip_address).to be_present
      end

      it "enqueues a ClickRecordingJob" do
        expect {
           get "/#{link.slug}"
        }.to have_enqueued_job(ClickRecordingJob)
      end
    end

    context "when the slug does not exist" do
      it "returns a 404 status" do
        get "/nonexistent"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
