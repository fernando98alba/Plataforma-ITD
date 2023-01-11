require "test_helper"

class TobesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tobe = tobes(:one)
  end

  test "should get index" do
    get tobes_url
    assert_response :success
  end

  test "should get new" do
    get new_tobe_url
    assert_response :success
  end

  test "should create tobe" do
    assert_difference("Tobe.count") do
      post tobes_url, params: { tobe: { capitalestrategico: @tobe.capitalestrategico, capitalestructural: @tobe.capitalestructural, capitalhumano: @tobe.capitalhumano, capitalnatural: @tobe.capitalnatural, capitalrelacional: @tobe.capitalrelacional } }
    end

    assert_redirected_to tobe_url(Tobe.last)
  end

  test "should show tobe" do
    get tobe_url(@tobe)
    assert_response :success
  end

  test "should get edit" do
    get edit_tobe_url(@tobe)
    assert_response :success
  end

  test "should update tobe" do
    patch tobe_url(@tobe), params: { tobe: { capitalestrategico: @tobe.capitalestrategico, capitalestructural: @tobe.capitalestructural, capitalhumano: @tobe.capitalhumano, capitalnatural: @tobe.capitalnatural, capitalrelacional: @tobe.capitalrelacional } }
    assert_redirected_to tobe_url(@tobe)
  end

  test "should destroy tobe" do
    assert_difference("Tobe.count", -1) do
      delete tobe_url(@tobe)
    end

    assert_redirected_to tobes_url
  end
end
