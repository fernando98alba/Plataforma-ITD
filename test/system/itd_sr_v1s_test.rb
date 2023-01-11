require "application_system_test_case"

class ItdSrV1sTest < ApplicationSystemTestCase
  setup do
    @itd_sr_v1 = itd_sr_v1s(:one)
  end

  test "visiting the index" do
    visit itd_sr_v1s_url
    assert_selector "h1", text: "Itd sr v1s"
  end

  test "should create itd sr v1" do
    visit itd_sr_v1s_url
    click_on "New itd sr v1"

    fill_in "P1", with: @itd_sr_v1.p1
    fill_in "P2", with: @itd_sr_v1.p2
    fill_in "P3", with: @itd_sr_v1.p3
    fill_in "P4", with: @itd_sr_v1.p4
    fill_in "P5", with: @itd_sr_v1.p5
    click_on "Create Itd sr v1"

    assert_text "Itd sr v1 was successfully created"
    click_on "Back"
  end

  test "should update Itd sr v1" do
    visit itd_sr_v1_url(@itd_sr_v1)
    click_on "Edit this itd sr v1", match: :first

    fill_in "P1", with: @itd_sr_v1.p1
    fill_in "P2", with: @itd_sr_v1.p2
    fill_in "P3", with: @itd_sr_v1.p3
    fill_in "P4", with: @itd_sr_v1.p4
    fill_in "P5", with: @itd_sr_v1.p5
    click_on "Update Itd sr v1"

    assert_text "Itd sr v1 was successfully updated"
    click_on "Back"
  end

  test "should destroy Itd sr v1" do
    visit itd_sr_v1_url(@itd_sr_v1)
    click_on "Destroy this itd sr v1", match: :first

    assert_text "Itd sr v1 was successfully destroyed"
  end
end
