require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 
  # test "the truth" do
  #   assert true
  # end
  #show, index
  test "should show profile" do
    user = users(:one)
    sign_in user
    get user_path user
    assert_response :success
  end
  test "should show index" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    sign_in user
    get empresa_users_path empresa
    assert_response :success
  end
  test "should not show profile if current_user is not user" do
    user = users(:one)
    user2 = users(:two)
    sign_in user2
    get user_path user
    assert_redirected_to root_path
  end
  test "should not show index if user not from empresa" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    user2 = users(:five)
    sign_in user2
    get empresa_users_path empresa
    assert_redirected_to root_path
  end
  test "should be able to invite user" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: "example@example.com"}
    assert_difference "User.count", 1 do
      post invite_member_path empresa , params: {user: parameters}
      invited_user = User.find_by(email: "example@example.com")
      assert_not_equal nil, invited_user.invitation_token
      assert_equal "Usuario invitado con exito", flash[:alert]
      assert_redirected_to empresa_users_path empresa
    end
  end
  test "should not be able to invite user if email not valid" do  #no implementado porque de todas maneras no se guarda si no es valido y porque el form obliga que sea valido
  end
  test "should not to invite user if not admin" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    sign_in user
    parameters = {email: "example@example.com"}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      assert_redirected_to empresa_users_path empresa
    end
  end
  test "should not invite user if user has empresa" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: users(:five).email}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      assert_equal "Usuario ya pertenece a otra organización", flash[:alert]
      assert_redirected_to empresa_users_path empresa
    end
  end
  test "shoud resend invitation if user has been invited" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: "ejemplo2@ejemplo.com"}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      assert_equal "Invitación reenviada con exito", flash[:alert]
      assert_redirected_to empresa_users_path empresa
    end
  end
  test "should not invite user if admin from diferent empresa" do
    empresa = empresas(:one)
    user = empresas(:two).users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: "example@example.com"}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      assert_redirected_to root_path
    end
  end
  test "should not invite myself" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: user.email}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      user.reload
      assert_nil user.invitation_token
      assert_equal "No puedes agregarte a ti mismo", flash[:alert]
      assert_redirected_to empresa_users_path empresa
    end
  end
  test "should not invite users who are already in empresa" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {email: users(:two).email}
    assert_no_difference "User.count" do
      post invite_member_path empresa , params: {user: parameters}
      assert_equal "Usuario ya es parte de la organización", flash[:alert]
      assert_redirected_to empresa_users_path empresa
    end
  end
end
