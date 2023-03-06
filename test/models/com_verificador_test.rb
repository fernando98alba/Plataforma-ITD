require "test_helper"

class ComVerificadorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save ComVerificador" do
    com_ver = ComVerificador.new
    com_ver.itdind = itdinds(:one)
    com_ver.verificador = verificadors(:six)
    com_ver.state = 1 
    assert com_ver.save
  end

  test "should not save ComVerificador if state is invalid" do
    com_ver = ComVerificador.new
    com_ver.itdind = itdinds(:one)
    com_ver.verificador = verificadors(:six)
    com_ver.state = 3
    assert_not com_ver.save
  end
  
  test "should not save ComVerificador if state is not defined" do
    com_ver = ComVerificador.new
    com_ver.itdind = itdinds(:one)
    com_ver.verificador = verificadors(:six)
    assert_not com_ver.save
  end

  test "should not save ComVerificador if not assigned to Itdind" do
    com_ver = ComVerificador.new
    com_ver.verificador = verificadors(:six)
    com_ver.state = 1
    assert_not com_ver.save
  end
  
  test "should not save ComVerificador if not assigned to Verificador" do
    com_ver = ComVerificador.new
    com_ver.itdind = itdinds(:one)
    com_ver.state = 2
    assert_not com_ver.save
  end
end
