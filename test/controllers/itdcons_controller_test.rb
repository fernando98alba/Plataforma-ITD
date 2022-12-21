require "test_helper"

class ItdconsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get itdcons_index_url
    assert_response :success
  end
end
