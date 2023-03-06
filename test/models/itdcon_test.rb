require "test_helper"

class ItdconTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save Itdcon" do
    itd = Itdcon.new
    itd.empresa = empresas(:one)
    assert itd.save 
  end
  test "should not save Itdcon without empresa" do 
    itd = Itdcon.new
    assert_not itd.save 
  end
end
