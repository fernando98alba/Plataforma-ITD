require "test_helper"

class ItdindTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save Itdind" do
    itd = Itdind.new
    itd.itdcon = itdcons(:three)
    itd.user = users(:one)
    assert itd.save 
  end
  test "should not save Itdind without Itdcon" do 
    itd = Itdind.new
    itd.user = users(:one)
    (1..91).each do |i|
      itd["p#{i}"] = rand(4)
    end
    assert_not itd.save 
  end
  test "should not save Itdind without user" do 
    itd = Itdind.new
    itd.itdcon = itdcons(:three)
    (1..91).each do |i|
      itd["p#{i}"] = rand(4)
    end
    assert_not itd.save 
  end
  test "should not save Itdind if more than 4" do 
    itd = Itdind.new
    itd.itdcon = itdcons(:three)
    itd.user = users(:one)
    (2..91).each do |i|
      itd["p#{i}"] = rand(4)
    end
    itd["p1"] = 8
    assert_not itd.save 
  end
end
