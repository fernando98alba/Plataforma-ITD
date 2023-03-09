require "test_helper"

class EmpresaTest < ActiveSupport::TestCase
 
  test "should save empresa" do
    empresa = Empresa.new
    empresa.name = "Example"
    empresa.size = "small"
    empresa.sector = "Consulting"
    empresa.rut = "20072503-4"
    assert empresa.save
  end

  test "should not save empresa if param is missing" do
    empresa = Empresa.new
    empresa.size = "small"
    empresa.sector = "Consulting"
    empresa.rut = "20072503-4"
    assert_not empresa.save, "Saved without name"
    empresa.name = "Example"
    empresa.size = nil
    assert_not empresa.save, "Saved without size"
    empresa.size = "small"
    empresa.sector = nil
    assert_not empresa.save, "Saved without sector"
    empresa.sector = "Consulting"
    empresa.rut = nil
    assert_not empresa.save, "Saved without rut"
  end

  test "should not save empresa rut already used" do
    empresa = Empresa.new
    empresa.name = "Example"
    empresa.size = "small"
    empresa.sector = "Consulting"
    empresa.rut = "20072504-4"
    assert_not empresa.save
  end

end
