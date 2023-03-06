require "test_helper"

class ItdsinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save Itdsin" do
    itd = Itdsin.new
    (1..91).each do |identifier|
      itd["p#{identifier}"] = rand(5)
    end
    assert itd.save
  end
  test "should not save Itdsin if not completed" do
    itd = Itdsin.new
    (1..91).drop(rand(91)).each do |identifier|
      itd["p#{identifier}"] = rand(5)
    end
    assert_not itd.save
  end
  test "should not save Itdind if more than 4" do 
    itd = Itdsin.new
    (2..91).each do |i|
      itd["p#{i}"] = rand(4)
    end
    itd["p1"] = 8
    assert_not itd.save 
  end
end
