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

  test "should update itdcon, add itdinds and redirect to my itdind" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    itdcon.itdinds.find_by(user_id: user.id).delete
    count = 0
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "1"
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
    end
    assert_difference ->{Itdind.count} => count  do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      itdind = user.itdinds.last
      asigned_users.keys.each do |u|
        assert_not_nil itdcon.itdinds.find_by(user_id: u)
      end
      assert_redirected_to edit_empresa_itdcon_itdind_path(empresa, itdcon, itdind)
    end
  end

  test "should update itdcon, delete itdinds" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    itdcon.itdinds.each do |i|
      asigned_users[i.user_id.to_s] = "1"
    end
    asigned_users[user.id.to_s] = "0"
    assert_difference ->{Itdind.count} => -1  do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_nil itdcon.itdinds.find_by(user_id: user.id)
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should update itdcon, delete and add itdinds" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    count = -1
    empresa.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    asigned_users[users(:five).id.to_s] = "0"
    assert_difference ->{Itdind.count} => count  do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      asigned_users.keys.each do |u|
        if asigned_users[u] == "1"
          assert_not_nil itdcon.itdinds.find_by(user_id: u)
        else
          assert_nil itdcon.itdinds.find_by(user_id: u)
        end
      end
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not update itdcon, itdinds if no user selected" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    empresa.users.each do |u|
      asigned_users[u.id.to_s] = "0"
    end
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not update itdcon or itdind and redirect to index if user not admin" do
    empresa = empresas(:two)
    user = users(:five)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    count = -1
    empresa.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    asigned_users[user.id.to_s] = "0"
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not update itdcon or itdind and redirect to login if user not logged in" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    asigned_users = {}
    count = -1
    empresa.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    asigned_users[user.id.to_s] = "0"
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to new_user_session_path
    end
  end

  test "should not update itdcon or itdind and redirect to root if user not from empresa" do 
    empresa = empresas(:two)
    user = users(:one)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    count = -1
    empresa.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    asigned_users[user.id.to_s] = "0"
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to root_path
    end
  end

  test "should not update itdcon or itdind if users from other empresa were selected" do 
    empresa = empresas(:two)
    empresa2 = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: false)
    sign_in user
    asigned_users = {}
    count = -1
    empresa2.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end

  test "should not update itdcon or itdind if itdcon not pending" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: true)
    sign_in user
    asigned_users = {}
    count = -1
    empresa.users.each do |u|
      if ! itdcon.itdinds.find_by(user_id: u.id)
        count +=1
      end
      asigned_users[u.id.to_s] = "1"
    end
    asigned_users[user.id.to_s] = "0"
    assert_no_difference "Itdind.count" do
      patch empresa_itdcon_url(empresa, itdcon, params: {itdcon: asigned_users})
      assert_redirected_to empresa_itdcons_path(empresa)
    end
  end
end
