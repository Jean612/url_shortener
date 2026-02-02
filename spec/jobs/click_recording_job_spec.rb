require 'rails_helper'

RSpec.describe ClickRecordingJob, type: :job do
  describe "#perform" do
    let(:link) { create(:link) }
    let(:ip_address) { "8.8.8.8" }
    let(:user_agent) { "TestAgent" }

    it "creates a click record" do
      expect {
        described_class.perform_now(link_id: link.id, ip_address: ip_address, user_agent: user_agent)
      }.to change(Click, :count).by(1)
    end

    it "sets the correct attributes on the click" do
      described_class.perform_now(link_id: link.id, ip_address: ip_address, user_agent: user_agent)
      click = Click.last
      expect(click.link).to eq(link)
      expect(click.ip_address).to eq(ip_address)
      expect(click.user_agent).to eq(user_agent)
    end

    it "performs geocoding" do
      # Mock Geocoder
      search_result = double(country: "United States")
      allow(Geocoder).to receive(:search).with(ip_address).and_return([ search_result ])

      described_class.perform_now(link_id: link.id, ip_address: ip_address, user_agent: user_agent)

      click = Click.last
      expect(click.country).to eq("United States")
    end

    it "handles geocoding errors gracefully" do
      allow(Geocoder).to receive(:search).and_raise(StandardError, "Service unavailable")

      expect {
        described_class.perform_now(link_id: link.id, ip_address: ip_address, user_agent: user_agent)
      }.not_to raise_error

      click = Click.last
      expect(click.country).to be_nil
    end

    it "does nothing if link is not found" do
       expect {
        described_class.perform_now(link_id: -1, ip_address: ip_address, user_agent: user_agent)
      }.not_to change(Click, :count)
    end
  end
end
