require "test_helper"

class ItdindsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  # [:show, :edit, :update]
  test "should redirect to my itdind report" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true)
    user = itdind.user
    sign_in user
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_response :success
  end
  test "should redirect to itdind report as admin" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    admin = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true, user_id: user.id)
    sign_in admin
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_response :success
  end
  test "should not show to itdind report if current user not itdind user and current user not admin" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    admin = empresa.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true, user_id: admin.id)
    sign_in user
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to empresa_itdcons_url empresa
  end
  test "should not show to itdind report if not logged in" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true)
    user = itdind.user
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to new_user_session_path
  end
  test "should not show to itdind report if user is admin but not from empresa" do
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    user = empresa.users.find_by(is_admin: 0)
    admin = empresa2.users.find_by(is_admin: 1)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true, user_id: user.id)
    sign_in admin
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to empresa_itdcons_url empresa
  end
  test "should not show to itdind report if itdcon not from empresa" do
    empresa = empresas(:one)
    empresa2 = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdind = itdcon.itdinds.find_by(completed: true)
    user = itdind.user
    sign_in user
    get empresa_itdcon_itdind_url empresa2, itdcon, itdind
    assert_redirected_to root_path
  end
  test "should not show to itdind report if itdind not from itdcon" do
    empresa = empresas(:one)
    list_itdcon = empresa.itdcons.where(completed: true)
    itdcon = list_itdcon[0]
    itdcon2 = list_itdcon[1]
    itdind = itdcon.itdinds.find_by(completed: true)
    user = itdind.user
    sign_in user
    get empresa_itdcon_itdind_url empresa, itdcon2, itdind
    assert_redirected_to root_path
  end
  test "should not show to itdind report if itdcon not completed" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: false)
    itdind = itdcon.itdinds.find_by(completed: true)
    user = itdind.user
    sign_in user
    get empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to empresa_itdcons_url empresa
  end

  test "should show edit" do
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    get edit_empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_response :success
  end
  test "should be able to update itdind and com_verificador" do 
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    parameters = {}
    (73..80).each do |index|
      parameters["p#{index}"] = rand(4)
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_difference "ComVerificador.count", count do
      patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
      itdind.reload
      itdcon.reload
      com_verificador.reload
      (73..80).each do |index|
        assert_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal false, itdind["completed"]
      assert_equal false, itdcon["completed"]
      assert_equal 2, com_verificadors(:one).state
      assert_equal "Changed", com_verificadors(:one).comment
      assert_redirected_to edit_empresa_itdcon_itdind_path empresa, itdcon, itdind
    end
  end

  test "should be able to complete itdind and com_verificador and redirect to itdcon report if completed" do
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    parameters = {}
    (1..91).each do |index|
      parameters["p#{index}"] = rand(4)
    end
    parameters_ver = {}
    parameters["com_verificadors_atributtes"] = parameters_ver
    patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
    itdind.reload
    itdcon.reload
    (1..91).each do |index|
      assert_equal parameters["p#{index}"], itdind["p#{index}"]
    end
    assert_equal true, itdind["completed"], "itdind false"
    assert_equal true, itdcon["completed"], "itdcon false"
    assert_redirected_to empresa_itdcon_path empresa, itdcon
  end
  test "should be able to complete itdind and com_verificador and redirect to index if not completed" do 
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    itdind2 = itdcon.itdinds.find_by(completed: true)
    itdind2.completed = false
    itdind2.save
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    parameters = {}
    (1..91).each do |index|
      parameters["p#{index}"] = rand(4)
    end
    parameters_ver = {}
    parameters["com_verificadors_atributtes"] = parameters_ver
    patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
    itdind.reload
    itdcon.reload
    (1..91).each do |index|
      assert_equal parameters["p#{index}"], itdind["p#{index}"]
    end
    assert_equal true, itdind["completed"], "itdind false"
    assert_equal false, itdcon["completed"], "itdcon true"
    assert_redirected_to empresa_itdcons_path empresa
  end
  test "should not show edit if current user not itdind user" do 
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdcon.itdinds.find_by(completed: true).user
    sign_in user
    get edit_empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to empresa_itdcons_path empresa
  end
  test "should not show edit if itdind completed" do 
    itdind = Itdind.find_by(completed: true)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    get edit_empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to empresa_itdcons_path empresa
  end
  test "should not show edit if not logged in" do
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    get edit_empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to new_user_session_path
  end

  test "should not show edit if itdcon not from empresa" do
    empresa = empresas(:one)
    itdcon = empresas(:two).itdcons.find_by(completed: false)
    itdind = itdcon.itdinds.find_by(completed: false)
    user = itdind.user
    sign_in user
    get edit_empresa_itdcon_itdind_url empresa, itdcon, itdind
    assert_redirected_to root_path
  end
  test "should not not show edit if itdind not from itdcon" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: false)
    itdcon2 = Itdcon.new
    itdind = itdcon.itdinds.find_by(completed: false)
    user = itdind.user
    itdcon2.empresa = empresa
    itdcon2.save
    sign_in user
    get edit_empresa_itdcon_itdind_url empresa, itdcon2, itdind
    assert_redirected_to root_path
  end

  test "should not allow update if current user not itdind user" do
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdcon.itdinds.find_by(completed: true).user
    sign_in user
    parameters = {}
    (70..91).each do |index|
      parameters["p#{index}"] = rand(4)
      while parameters["p#{index}"] == itdind["p#{index}"]
        parameters["p#{index}"] = rand(4)
      end
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_no_difference "ComVerificador.count" do
      patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
      itdind.reload
      com_verificador.reload
      (70..91).each do |index|
        assert_not_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal false, itdind["completed"]
      assert_redirected_to empresa_itdcons_path empresa
    end
  end
  test "should not allow update itdind if itdind completed" do 
    itdind = Itdind.find_by(completed: true)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    sign_in user
    parameters = {}
    (70..80).each do |index|
      parameters["p#{index}"] = rand(4)
      while parameters["p#{index}"] == itdind["p#{index}"]
        parameters["p#{index}"] = rand(4)
      end
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_no_difference "ComVerificador.count" do
      patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
      itdind.reload
      com_verificador.reload
      (70..80).each do |index|
        assert_not_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal true, itdind["completed"]
      assert_redirected_to empresa_itdcons_path empresa
    end
  end
  test "should not allow update itdind if not logged in" do
    itdind = Itdind.find_by(completed: false)
    itdcon = itdind.itdcon
    empresa = itdcon.empresa
    user = itdind.user
    parameters = {}
    (73..91).each do |index|
      parameters["p#{index}"] = rand(4)
      while parameters["p#{index}"] == itdind["p#{index}"]
        parameters["p#{index}"] = rand(4)
      end
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_no_difference "ComVerificador.count" do
      patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
      itdind.reload
      itdcon.reload
      com_verificador.reload
      (73..91).each do |index|
        assert_not_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal false, itdind["completed"]
      assert_redirected_to new_user_session_path
    end
  end
  test "should not allow update itdind if itdcon not from empresa" do
    empresa = empresas(:one)
    itdcon = empresas(:two).itdcons.find_by(completed: false)
    itdind = itdcon.itdinds.find_by(completed: false)
    user = itdind.user
    sign_in user
    parameters = {}
    (73..91).each do |index|
      parameters["p#{index}"] = rand(4)
      while parameters["p#{index}"] == itdind["p#{index}"]
        parameters["p#{index}"] = rand(4)
      end
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_no_difference "ComVerificador.count" do
      patch empresa_itdcon_itdind_url empresa, itdcon, itdind, params: {itdind: parameters}
      itdind.reload
      itdcon.reload
      com_verificador.reload
      (73..91).each do |index|
        assert_not_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal false, itdind["completed"]
      assert_redirected_to root_path
    end
  end
  test "should not allow update itdind if itdind not from itdcon" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: false)
    itdcon2 = Itdcon.new
    itdind = itdcon.itdinds.find_by(completed: false)
    user = itdind.user
    itdcon2.empresa = empresa
    itdcon2.save
    sign_in user
    parameters = {}
    (73..91).each do |index|
      parameters["p#{index}"] = rand(4)
      while parameters["p#{index}"] == itdind["p#{index}"]
        parameters["p#{index}"] = rand(4)
      end
    end
    parameters_ver = {}
    count = 0
    Driver.all.each do |driver|
      driver.verificadors.all.each do |verificador|
        if com_verificadors(:one).verificador.id == verificador.id
          parameters_ver["ver"+verificador.id.to_s] = "2"
          parameters_ver["comment_"+verificador.id.to_s] = "Changed"
        else
          parameters_ver["ver"+verificador.id.to_s] = rand(2).to_s
          if parameters_ver["ver"+verificador.id.to_s] != "0"
            count +=1
          end
          parameters_ver["comment_"+verificador.id.to_s] = ""
        end
      end
    end
    com_verificador = com_verificadors(:one)
    parameters["com_verificadors_atributtes"] = parameters_ver
    assert_no_difference "ComVerificador.count" do
      patch empresa_itdcon_itdind_url empresa, itdcon2, itdind, params: {itdind: parameters}
      itdind.reload
      itdcon.reload
      com_verificador.reload
      (73..91).each do |index|
        assert_not_equal parameters["p#{index}"], itdind["p#{index}"]
      end
      assert_equal false, itdind["completed"]
      assert_redirected_to root_path
    end
  end

end
