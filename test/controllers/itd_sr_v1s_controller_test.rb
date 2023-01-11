require "test_helper"

class ItdSrV1sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @itd_sr_v1 = itd_sr_v1s(:one)
  end

  test "should get index" do
    get itd_sr_v1s_url
    assert_response :success
  end

  test "should get new" do
    get new_itd_sr_v1_url
    assert_response :success
  end

  test "should create itd_sr_v1" do
    assert_difference("ItdSrV1.count") do
      post itd_sr_v1s_url, params: { itd_sr_v1: { p1: @itd_sr_v1.p1, p2: @itd_sr_v1.p2, p3: @itd_sr_v1.p3, p4: @itd_sr_v1.p4, p5: @itd_sr_v1.p5 } }
    end

    assert_redirected_to itd_sr_v1_url(ItdSrV1.last)
  end

  test "should show itd_sr_v1" do
    get itd_sr_v1_url(@itd_sr_v1)
    assert_response :success
  end

  test "should get edit" do
    get edit_itd_sr_v1_url(@itd_sr_v1)
    assert_response :success
  end

  test "should update itd_sr_v1" do
    patch itd_sr_v1_url(@itd_sr_v1), params: { itd_sr_v1: { p1: @itd_sr_v1.p1, p2: @itd_sr_v1.p2, p3: @itd_sr_v1.p3, p4: @itd_sr_v1.p4, p5: @itd_sr_v1.p5 } }
    assert_redirected_to itd_sr_v1_url(@itd_sr_v1)
  end

  test "should destroy itd_sr_v1" do
    assert_difference("ItdSrV1.count", -1) do
      delete itd_sr_v1_url(@itd_sr_v1)
    end

    assert_redirected_to itd_sr_v1s_url
  end
end
