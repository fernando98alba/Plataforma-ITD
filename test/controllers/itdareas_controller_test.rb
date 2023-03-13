require "test_helper"

class ItdareasControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get itdareas_show_url
    assert_response :success
  end
end
