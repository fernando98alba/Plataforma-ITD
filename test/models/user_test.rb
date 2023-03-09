require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should save user" do 
    user = User.new
    user.name = "Example"
    user.lastname = "Name"
    user.email = "example@example.com"
    user.password = "Maa12$"
    user.empresa = empresas(:two)
    assert user.save
  end
  test "should not save if param is missing" do 
    user = User.new
    user.lastname = "Name"
    user.email = "example@example.com"
    user.password = "Maa12$"
    user.empresa = empresas(:two)
    assert_not user.save, "User saved without name"
    user.name = "Example"
    user.lastname = nil
    assert_not user.save, "User saved without lastname"
    user.lastname = "Name"
    user.email = nil
    assert_not user.save, "User saved without email"
    user.email = "example@example.com"
    user.password = nil
    assert_not user.save, "User saved without password"
  end
  
  test "should not save if password is to simple" do
    user = User.new
    user.name = "Example"
    user.lastname = "Name"
    user.email = "example@example.com"
    user.password = "123456"
    user.empresa = empresas(:two)
    assert_not user.save
  end
end
