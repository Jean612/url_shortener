require "test_helper"

class ShortLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get short_links_show_url
    assert_response :success
  end
end
