require "test_helper"
class EmpresasControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 
  #La creacion se testea en user_testing

  test "should show empresa" do
    user = users(:one)
    sign_in user
    empresa = user.empresa
    get empresa_url(empresa)
    assert_response :success
  end

  test "should not show empresa if user not of empresa" do
    user = users(:one)
    sign_in(user)
    empresa = user.empresa
    get empresa_url(empresas(:two))
    assert_redirected_to root_path
  end

  test "should not show empresa if user not logged in" do
    get empresa_url(empresas(:two))
    assert_redirected_to new_user_session_path
    get empresa_url(empresas(:one))
    assert_redirected_to new_user_session_path
  end

end
