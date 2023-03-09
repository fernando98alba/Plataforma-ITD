require "test_helper"

class ComVerificadorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get con_verificadors_index_url
    assert_response :success
  end
end
