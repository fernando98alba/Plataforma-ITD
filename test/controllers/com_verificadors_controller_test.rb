require "test_helper"

class ComVerificadorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 

  test "should redirect to verificadors report" do
    user = users(:one)
    sign_in user
    empresa = user.empresa
    itdcon = itdcons(:one)
    get empresa_itdcon_com_verificadors_url empresa, itdcon
    assert_response :success
  end

  test "should not show verificadors if user not logged in" do 
    user = users(:one)
    empresa = user.empresa
    itdcon = itdcons(:one)
    get empresa_itdcon_com_verificadors_url empresa, itdcon
    assert_redirected_to new_user_session_path
  end

  test "should not show verificadors if user not from empresa" do 
    empresa = empresas(:one)
    user = users(:five)
    sign_in user
    itdcon = itdcons(:one)
    get empresa_itdcon_com_verificadors_url empresa, itdcon
    assert_redirected_to root_path
  end

  test "should not show verificadors if itdcon not from empresa" do
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    user = users(:five)
    sign_in user
    itdcon = itdcons(:one)
    get empresa_itdcon_com_verificadors_url empresa2, itdcon
    assert_redirected_to root_path
  end

  test "should not show verificadors if itdcon not completed" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: false)
    user = users(:five)
    sign_in user
    get empresa_itdcon_com_verificadors_url empresa, itdcon
    assert_redirected_to empresa_itdcons_url empresa
  end
end
