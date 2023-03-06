require "test_helper"

class AspiracionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should save aspiracion" do 
    aspiracion = Aspiracion.new
    aspiracion.maturity_score = 60
    aspiracion.alignment_score = 5
    aspiracion["estratégico"] = 59
    aspiracion["estructural"] = 59
    aspiracion["humano"] = 60
    aspiracion["relacional"] = 59
    aspiracion["natural"] = 64
    aspiracion["estrategia"] = 53
    aspiracion["modelos_de_negocios"] = 71
    aspiracion["governance"] = 53
    aspiracion["procesos"] = 59
    aspiracion["tecnología"] = 59
    aspiracion["datos_y_analítica"] = 59
    aspiracion["modelo_operativo"] = 59
    aspiracion["propiedad_intelectual"] = 59
    aspiracion["personas"] = 55
    aspiracion["ciclo_de_vida_del_colaborador"] = 56
    aspiracion["estructura_organizacional"] = 70
    aspiracion["stakeholders"] = 59
    aspiracion["marca"] = 59
    aspiracion["clientes"] = 59
    aspiracion["sustentabilidad"] = 65
    aspiracion.empresa = empresas(:one)
    assert aspiracion.save
  end
  test "should not save aspiracion with missing parameter" do
    aspiracion = Aspiracion.new
    aspiracion.maturity_score = 60
    aspiracion["estructural"] = 59
    aspiracion["humano"] = 60
    aspiracion["relacional"] = 59
    aspiracion["natural"] = 64
    aspiracion["estrategia"] = 53
    aspiracion["modelos_de_negocios"] = 71
    aspiracion["governance"] = 53
    aspiracion["tecnología"] = 59
    aspiracion["datos_y_analítica"] = 59
    aspiracion["modelo_operativo"] = 59
    aspiracion["propiedad_intelectual"] = 59
    aspiracion["personas"] = 55
    aspiracion["ciclo_de_vida_del_colaborador"] = 56
    aspiracion["estructura_organizacional"] = 70
    aspiracion["stakeholders"] = 59
    aspiracion["marca"] = 59
    aspiracion["clientes"] = 59
    aspiracion["sustentabilidad"] = 65
    aspiracion.empresa = empresas(:one)
    assert_not aspiracion.save
  end
  test "should not save aspiracion without empresa" do
    aspiracion = Aspiracion.new
    aspiracion.maturity_score = 60
    aspiracion["estructural"] = 59
    aspiracion["humano"] = 60
    aspiracion["relacional"] = 59
    aspiracion["natural"] = 64
    aspiracion["estrategia"] = 53
    aspiracion["modelos_de_negocios"] = 71
    aspiracion["governance"] = 53
    aspiracion["tecnología"] = 59
    aspiracion["datos_y_analítica"] = 59
    aspiracion["modelo_operativo"] = 59
    aspiracion["propiedad_intelectual"] = 59
    aspiracion["personas"] = 55
    aspiracion["ciclo_de_vida_del_colaborador"] = 56
    aspiracion["estructura_organizacional"] = 70
    aspiracion["stakeholders"] = 59
    aspiracion["marca"] = 59
    aspiracion["clientes"] = 59
    aspiracion["sustentabilidad"] = 65
    assert_not aspiracion.save
  end
end
