require "test_helper"

class ItdconsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  #show, index, create

  test "should redirect to itdcon report" do
    user = users(:one)
    sign_in user
    empresa = user.empresa
    itdcon = empresa.itdcons.find_by(completed: true)
    get empresa_itdcon_url empresa, itdcon
    assert_response :success
  end

  test "should not show itdcon if user not logged in" do 
    user = users(:one)
    empresa = user.empresa
    itdcon = empresa.itdcons.find_by(completed: true)
    get empresa_itdcon_url empresa, itdcon
    assert_redirected_to new_user_session_path
  end

  test "should not show itdcon if user not from empresa" do 
    empresa = empresas(:one)
    user = users(:five)
    sign_in user
    itdcon = empresa.itdcons.find_by(completed: true)
    get empresa_itdcon_url empresa, itdcon
    assert_redirected_to root_path
  end

  test "should not show itdcon if itdcon not from empresa" do
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    user = users(:five)
    sign_in user
    itdcon = empresa.itdcons.find_by(completed: true)
    get empresa_itdcon_url empresa2, itdcon
    assert_redirected_to root_path
  end

  test "should not show itdcon if itdcon not completed" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: false)
    user = users(:five)
    sign_in user
    get empresa_itdcon_url empresa, itdcon
    assert_redirected_to empresa_itdcons_url empresa
  end

  test "should redirect to empresa's itdcons" do
    user = users(:one)
    sign_in user
    empresa = user.empresa
    itdcon = empresa.itdcons.all
    get empresa_itdcons_url empresa
    assert_response :success
  end

  test "should not redirect to empresa's itdcons if user not logged in" do 
    user = users(:one)
    empresa = user.empresa
    get empresa_itdcons_url empresa
    assert_redirected_to new_user_session_path
  end

  test "should not redirect to empresa's itdcons if user not from empresa" do 
    empresa = empresas(:one)
    user = users(:five)
    sign_in user
    get empresa_itdcons_url empresa
    assert_redirected_to root_path
  end

  test "should create itdcon, itdinds and redirect to my itdind" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    count = empresa.users.length
    assert_difference ->{Itdcon.count} => 1, ->{Itdind.count} => count  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      itdind = user.itdinds.last
      itdcon = empresa.itdcons.last
      assert_redirected_to edit_empresa_itdcon_itdind_path(empresa, itdcon, itdind)
    end
  end

  test "should create itdcon, itdinds and render index" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      if u != user
        asigned_users[u.id.to_s] = "1"
      end
    end
    count = empresa.users.length-1
    assert_difference ->{Itdcon.count} => 1, ->{Itdind.count} => count  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not create itdcon or itdind and redirect to index if no user chosen" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "0"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not create itdcon or itdind and redirect to index if user not admin" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not create itdcon or itdind and redirect to login if user not logged in" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to new_user_session_path
    end
  end

  test "should not create itdcon or itdind and redirect to root if user not from empresa" do 
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    user = empresa2.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to root_path
    end
  end

  test "should not create itdcon or itdind if users from other empresa were selected" do 
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa2.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not create itdcon or itdind if itdcon pending" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference ["Itdcon.count", "Itdind.count"]  do
      post empresa_itdcons_url(empresa, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end
end
