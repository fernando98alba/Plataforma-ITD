require "test_helper"

class AspiracionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 
  # test "the truth" do
  #   assert true
  # end
  #index, show, create,
  test "should redirect to current aspiracion" do
    user = users(:one)
    sign_in user
    empresa = user.empresa
    aspiracion = empresa.aspiracion
    get empresa_aspiracion_url empresa, aspiracion
    assert_response :success
  end

  test "should not show current aspiracion if user not logged in" do 
    user = users(:one)
    empresa = user.empresa
    aspiracion = empresa.aspiracion
    get empresa_aspiracion_url empresa, aspiracion
    assert_redirected_to new_user_session_path
  end

  test "should not show current aspiracion if user not from empresa" do 
    empresa = empresas(:one)
    user = users(:five)
    sign_in user
    aspiracion = empresa.aspiracion
    get empresa_aspiracion_url empresa, aspiracion
    assert_redirected_to root_path
  end

  test "should not show current aspiracion if aspiracion not from empresa" do #obtengo la aspiracion de la empresa así que da lo mismo que sea @aspiracion
  end

  test "should not show current aspiracion if aspiracion doesn't exists and redirect to new aspiracion" do
    empresa = empresas(:two)
    user = users(:five)
    sign_in user
    aspiracion = empresas(:one).aspiracion
    get empresa_aspiracion_url empresa, aspiracion
    assert_redirected_to empresa_aspiracions_path(empresa)
  end

  test "should create new aspiracion" do
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 52.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    assert_difference "Aspiracion.count", 1 do
      post empresa_aspiracions_url empresa, params: {aspiracion: parameters}
      aspiracion = Aspiracion.last
      assert_equal empresa.id, aspiracion.empresa.id, "aa"
      parameters.keys.each do |key|
        assert_equal parameters[key].round(4), aspiracion[key].round(4)
      end
      assert_redirected_to empresa_aspiracion_url empresa, aspiracion
    end
  end
  test "should update aspiracion" do
    parameters = {}
    parameters[:maturity_score] = 61.2092206790124
    parameters[:alignment_score] = 61.00253468466077
    parameters[:estratégico] = 61.1607222222222
    parameters[:estructural] = 61.1607222222222
    parameters[:humano] = 61.3395061728395
    parameters[:relacional] = 61.1607222222222
    parameters[:natural] = 65.5833333333334
    parameters[:estrategia] = 53.9513888888889
    parameters[:modelos_de_negocios] = 71.8333333333334
    parameters[:governance] = 53.9513888888889
    parameters[:procesos] = 61.3333333333333
    parameters[:tecnología] = 61.3333333333333
    parameters[:datos_y_analítica] = 61.3333333333333
    parameters[:modelo_operativo] = 61.3333333333333
    parameters[:propiedad_intelectual] = 61.3333333333333
    parameters[:personas] = 56.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 57.0185185185185
    parameters[:estructura_organizacional] = 70.7916666666667
    parameters[:stakeholders] = 61.3333333333334
    parameters[:marca] = 61.3333333333334
    parameters[:clientes] = 61.3333333333334
    parameters[:sustentabilidad] = 65.5833333333334
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    aspiracion = empresa.aspiracion
    sign_in user
    assert_no_difference "Aspiracion.count" do
      patch empresa_aspiracion_url(empresa, aspiracion), params: {aspiracion: parameters}
      aspiracion.reload
      parameters.keys.each do |key|
        assert_equal parameters[key].round(4), aspiracion[key].round(4)
      end
      assert_redirected_to empresa_aspiracion_url empresa, aspiracion
    end
  end
  test "should not create aspiracion if user not admin" do 
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 53.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    user.is_admin = 0
    user.save
    sign_in user
    assert_no_difference "Aspiracion.count" do
      post empresa_aspiracions_url empresa, params: {aspiracion: parameters}
      assert_redirected_to root_path
    end
  end
  test "should not update aspiracion if not admin" do
    parameters = {}
    parameters[:maturity_score] = 61.2092206790124
    parameters[:alignment_score] = 61.00253468466077
    parameters[:estratégico] = 61.1607222222222
    parameters[:estructural] = 61.1607222222222
    parameters[:humano] = 61.3395061728395
    parameters[:relacional] = 61.1607222222222
    parameters[:natural] = 65.5833333333334
    parameters[:estrategia] = 53.9513888888889
    parameters[:modelos_de_negocios] = 71.8333333333334
    parameters[:governance] = 53.9513888888889
    parameters[:procesos] = 61.3333333333333
    parameters[:tecnología] = 61.3333333333333
    parameters[:datos_y_analítica] = 61.3333333333333
    parameters[:modelo_operativo] = 61.3333333333333
    parameters[:propiedad_intelectual] = 61.3333333333333
    parameters[:personas] = 56.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 57.0185185185185
    parameters[:estructura_organizacional] = 70.7916666666667
    parameters[:stakeholders] = 61.3333333333334
    parameters[:marca] = 61.3333333333334
    parameters[:clientes] = 61.3333333333334
    parameters[:sustentabilidad] = 65.5833333333334
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    aspiracion = empresa.aspiracion
    sign_in user
    assert_no_difference "Aspiracion.count" do
      patch empresa_aspiracion_url(empresa, aspiracion), params: {aspiracion: parameters}
      aspiracion.reload
      parameters.keys.each do |key|
        assert_not_equal parameters[key].round(4), aspiracion[key].round(4)
      end
      assert_redirected_to root_path
    end
  end
  test "should not create aspiracion if user not from empresa" do
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 52.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:two)
    user = empresas(:one).users.find_by(is_admin: 1)
    sign_in user
    assert_no_difference "Aspiracion.count" do
      post empresa_aspiracions_url empresa, params: {aspiracion: parameters}
      assert_redirected_to root_path
    end
  end
  test "should not update aspiracion if user not from empresa" do
    parameters = {}
    parameters[:maturity_score] = 61.2092206790124
    parameters[:alignment_score] = 61.00253468466077
    parameters[:estratégico] = 61.1607222222222
    parameters[:estructural] = 61.1607222222222
    parameters[:humano] = 61.3395061728395
    parameters[:relacional] = 61.1607222222222
    parameters[:natural] = 65.5833333333334
    parameters[:estrategia] = 53.9513888888889
    parameters[:modelos_de_negocios] = 71.8333333333334
    parameters[:governance] = 53.9513888888889
    parameters[:procesos] = 61.3333333333333
    parameters[:tecnología] = 61.3333333333333
    parameters[:datos_y_analítica] = 61.3333333333333
    parameters[:modelo_operativo] = 61.3333333333333
    parameters[:propiedad_intelectual] = 61.3333333333333
    parameters[:personas] = 56.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 57.0185185185185
    parameters[:estructura_organizacional] = 70.7916666666667
    parameters[:stakeholders] = 61.3333333333334
    parameters[:marca] = 61.3333333333334
    parameters[:clientes] = 61.3333333333334
    parameters[:sustentabilidad] = 65.5833333333334
    empresa = empresas(:one)
    aspiracion = empresa.aspiracion
    user = empresas(:two).users.find_by(is_admin: 1)
    sign_in user
    assert_no_difference "Aspiracion.count" do
      patch empresa_aspiracion_url(empresa, aspiracion), params: {aspiracion: parameters}
      aspiracion.reload
      parameters.keys.each do |key|
        assert_not_equal parameters[key].round(4), aspiracion[key].round(4)
      end
      assert_redirected_to root_path
    end
  end
  test "should not create aspiracion if not logged in" do
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 52.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    assert_no_difference "Aspiracion.count" do
      post empresa_aspiracions_url empresa, params: {aspiracion: parameters}
      assert_redirected_to new_user_session_path
    end
  end
  test "should not update aspiracion if not logged in" do
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 52.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:one)
    aspiracion = empresa.aspiracion
    user = empresa.users.find_by(is_admin: 1)
    assert_no_difference "Aspiracion.count" do
      patch empresa_aspiracion_url(empresa, aspiracion), params: {aspiracion: parameters}
      assert_redirected_to new_user_session_path
    end
  end
  test "should not create aspiracion if no itcon" do
    parameters = {}
    parameters[:maturity_score] = 60.2092206790124
    parameters[:alignment_score] = 5.00253468465977
    parameters[:estratégico] = 59.1597222222222
    parameters[:estructural] = 59.1597222222222
    parameters[:humano] = 60.3395061728395
    parameters[:relacional] = 59.1597222222222
    parameters[:natural] = 64.5833333333334
    parameters[:estrategia] = 52.9513888888889
    parameters[:modelos_de_negocios] = 70.8333333333334
    parameters[:governance] = 52.9513888888889
    parameters[:procesos] = 59.3333333333333
    parameters[:tecnología] = 59.3333333333333
    parameters[:datos_y_analítica] = 59.3333333333333
    parameters[:modelo_operativo] = 59.3333333333333
    parameters[:propiedad_intelectual] = 59.3333333333333
    parameters[:personas] = 55.2083333333333
    parameters[:ciclo_de_vida_del_colaborador] = 56.0185185185185
    parameters[:estructura_organizacional] = 69.7916666666667
    parameters[:stakeholders] = 59.3333333333334
    parameters[:marca] = 59.3333333333334
    parameters[:clientes] = 59.3333333333334
    parameters[:sustentabilidad] = 64.5833333333334
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    itdcon = empresa.itdcons.find_by(completed: true)
    itdcon.itdinds.each do |i|
      i.delete
    end
    itdcon.delete
    assert_no_difference "Aspiracion.count" do
      post empresa_aspiracions_url empresa, params: {aspiracion: parameters}
      assert_redirected_to empresa_itdcons_path empresa
    end
  end

  test "should show index to create aspiracion" do
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_response :success
  end
  test "should show index to update aspiracion" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_response :success
  end
  test "should not show index to create aspiracion if user not admin" do 
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    user.is_admin = 0
    user.save
    sign_in user
    get empresa_aspiracions_url empresa
    assert_redirected_to root_path
  end
  test "should not show index to update aspiracion if user not admin" do 
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 0)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_redirected_to root_path
  end
  test "should not show index to create aspiracion if user not from empresa" do 
    empresa = empresas(:two)
    user = empresas(:one).users.find_by(is_admin: 1)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_redirected_to root_path
  end
  test "should not show index to update aspiracion if user not from empresa" do 
    empresa = empresas(:one)
    user = empresas(:two).users.find_by(is_admin: 1)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_redirected_to root_path
  end
  
  test "should not show index to create aspiracion if not logged in" do
    empresa = empresas(:two)
    user = empresa.users.find_by(is_admin: 1)
    get empresa_aspiracions_url empresa
    assert_redirected_to new_user_session_path
  end
  test "should not show index to update aspiracion if not logged in" do
    empresa = empresas(:one)
    user = empresa.users.find_by(is_admin: 1)
    get empresa_aspiracions_url empresa
    assert_redirected_to new_user_session_path
  end
  test "should not show index to create aspiracion if no itdcon" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    itdcon.itdinds.each do |i|
      i.delete
    end
    itdcon.delete
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    get empresa_aspiracions_url empresa
    assert_redirected_to empresa_itdcons_path empresa
  end

  # update_maturity_recomendation, update_dat_recomendation, update_hab_recomendation
  test "should create maturity recomendation with only maturity" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = itdcon["maturity_score"] + rand(100-itdcon["maturity_score"])
    parameters["alignment_score"] = ""
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", parameters["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", itdcon["alignment_score"]
  end

  test "should create maturity recomendation with only alignment" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] =""
    parameters["alignment_score"] =  itdcon["alignment_score"] - rand(itdcon["alignment_score"])
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", itdcon["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", parameters["alignment_score"]
  end
  test "should create maturity recomendation when maturity aspiration is too low for the alignment aspiration" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = itdcon["maturity_score"] + 1
    parameters["alignment_score"] =  5
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", parameters["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", parameters["alignment_score"]
  end
  test "should update maturity recomendation with only maturity" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = itdcon["maturity_score"] + rand(100-itdcon["maturity_score"])
    parameters["alignment_score"] = ""
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", parameters["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", itdcon["alignment_score"]
  end
  test "should update maturity recomendation with only alignment" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] =""
    parameters["alignment_score"] =  itdcon["alignment_score"] - rand(itdcon["alignment_score"])
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", itdcon["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", parameters["alignment_score"]
  end
  test "should update maturity recomendation when maturity aspiration is too low for the alignment aspiration" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = itdcon["maturity_score"] + 1
    parameters["alignment_score"] =  5
    post update_maturity_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    assert_operator recomendation["maturity_score"], ">=", parameters["maturity_score"]
    assert_operator recomendation["alignment_score"], "<=", parameters["alignment_score"]
  end

  test "should create dat recomendation" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = rand(60..100)
    parameters["alignment_score"] =  rand(0..13)
    parameters["estratégico"] = rand(50..100)
    parameters["estructural"] = rand(50..100)
    parameters["humano"] = rand(50..100)
    parameters["relacional"] = rand(50..100)
    parameters["natural"] = rand(50..100)
    post update_dat_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    recomendation.keys.each do |k|
      assert_equal recomendation[k], parameters[k]
    end
  end
  test "should update dat recomendation" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    parameters["maturity_score"] = rand(60..100)
    parameters["alignment_score"] =  rand(0..13)
    parameters["estratégico"] = rand(50..100)
    parameters["estructural"] = rand(50..100)
    parameters["humano"] = rand(50..100)
    parameters["relacional"] = rand(50..100)
    parameters["natural"] = rand(50..100)
    post update_dat_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
    recomendation = JSON.parse(response.body)
    recomendation.keys.each do |k|
      assert_equal recomendation[k], parameters[k]
    end
  end
  test "should create hab recomendation" do
    empresa = empresas(:two)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    hash = {estratégico: [:estrategia, :modelos_de_negocios, :governance], estructural: [:procesos, :tecnología, :datos_y_analítica, :modelo_operativo, :propiedad_intelectual], humano: [:personas, :ciclo_de_vida_del_colaborador, :estructura_organizacional], relacional: [:stakeholders, :marca, :clientes],natural: [:sustentabilidad]}
    parameters["maturity_score"] = rand(60..100)
    parameters["alignment_score"] =  rand(0..13)
    parameters["estratégico"] = rand(50..100)
    parameters["estructural"] = rand(50..100)
    parameters["humano"] = rand(50..100)
    parameters["relacional"] = rand(50..100)
    parameters["natural"] = rand(50..100)
    count = 0
    while count < dats.length
      count += 1
      dats = hash.keys
      dat = dats.delete_at(rand(dats.length-1))
      parameters["dat"] = dat
      hash[dat].each do |h|
        parameters[h.to_s] = rand(50..100)
      end
      post update_hab_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
      recomendation = JSON.parse(response.body)
      recomendation.keys.each do |k|
        recomendation[k].keys.each do |h|
          assert_equal recomendation[k][h], parameters[h]
        end
      end
    end
  end

  test "should update hab recomendation" do
    empresa = empresas(:one)
    itdcon = empresa.itdcons.find_by(completed: true)
    user = empresa.users.find_by(is_admin: 1)
    sign_in user
    parameters = {}
    hash = {estratégico: [:estrategia, :modelos_de_negocios, :governance], estructural: [:procesos, :tecnología, :datos_y_analítica, :modelo_operativo, :propiedad_intelectual], humano: [:personas, :ciclo_de_vida_del_colaborador, :estructura_organizacional], relacional: [:stakeholders, :marca, :clientes],natural: [:sustentabilidad]}
    parameters["maturity_score"] = rand(60..100)
    parameters["alignment_score"] =  rand(0..13)
    parameters["estratégico"] = rand(50..100)
    parameters["estructural"] = rand(50..100)
    parameters["humano"] = rand(50..100)
    parameters["relacional"] = rand(50..100)
    parameters["natural"] = rand(50..100)
    count = 0
    while count < dats.length
      count += 1
      dats = hash.keys
      dat = dats.delete_at(rand(dats.length-1))
      parameters["dat"] = dat
      hash[dat].each do |h|
        parameters[h.to_s] = rand(50..100)
      end
      post update_hab_recomendation_path(empresa, format: :json), params: {aspiracion: parameters}
      recomendation = JSON.parse(response.body)
      recomendation.keys.each do |k|
        recomendation[k].keys.each do |h|
          assert_equal recomendation[k][h], parameters[h]
        end
      end
    end
  end
end
