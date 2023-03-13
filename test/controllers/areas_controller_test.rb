require "test_helper"

class AreasControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get areas_create_url
    assert_response :success
  end
end
