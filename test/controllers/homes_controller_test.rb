require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 

  test "should get index if not ligged in" do
    get root_path
    assert_response :success
  end
  test "should redirect to landing_page" do
    user = users(:one)
    sign_in user
    get root_path
    assert_redirected_to empresa_url(user.empresa)
  end
end
