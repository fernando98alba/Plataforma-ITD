require "test_helper"

class ItdsinsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # test "the truth" do
  #   assert true
  # end
  test "show new" do
    get new_itdsin_path
    assert_response :success
  end
  test "not show new if logged in" do
    user = users(:one)
    sign_in user
    get new_itdsin_path
    assert_redirected_to root_path
  end
  test "create new" do 
    parameters = {id: 1}
    (1..91).each do |i|
      parameters["p#{i}"] = rand(4)
    end
    post itdsins_path params: {itdsin: parameters}
    itdsin = Itdsin.last
    assert_redirected_to itdsin_path itdsin
  end

  test "not create if logged in" do
    user = users(:one)
    sign_in user
    parameters = {id: 1}
    (1..91).each do |i|
      parameters["p#{i}"] = rand(4)
    end
    post itdsins_path params: {itdsin: parameters}
    assert_redirected_to root_path
  end

  test "show itdsin" do
    itdsin = itdsins(:one)
    get itdsin_path itdsin
    assert_response :success
  end
  test "not show itdsin if logged in" do
    user = users(:one)
    itdsin = itdsins(:one)
    sign_in user
    get new_itdsin_path
    assert_redirected_to root_path
  end
end
