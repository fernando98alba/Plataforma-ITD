require "test_helper"

class ItdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @itd = itds(:one)
  end

  test "should get index" do
    get itds_url
    assert_response :success
  end

  test "should get new" do
    get new_itd_url
    assert_response :success
  end

  test "should create itd" do
    assert_difference("Itd.count") do
      post itds_url, params: { itd: { p1: @itd.p1, p2: @itd.p2, p3: @itd.p3, p4: @itd.p4, p5: @itd.p5 } }
    end

    assert_redirected_to itd_url(Itd.last)
  end

  test "should show itd" do
    get itd_url(@itd)
    assert_response :success
  end

  test "should get edit" do
    get edit_itd_url(@itd)
    assert_response :success
  end

  test "should update itd" do
    patch itd_url(@itd), params: { itd: { p1: @itd.p1, p2: @itd.p2, p3: @itd.p3, p4: @itd.p4, p5: @itd.p5 } }
    assert_redirected_to itd_url(@itd)
  end

  test "should destroy itd" do
    assert_difference("Itd.count", -1) do
      delete itd_url(@itd)
    end

    assert_redirected_to itds_url
  end
end
