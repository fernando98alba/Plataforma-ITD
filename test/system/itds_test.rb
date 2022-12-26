require "application_system_test_case"

class ItdsTest < ApplicationSystemTestCase
  setup do
    @itd = itds(:one)
  end

  test "visiting the index" do
    visit itds_url
    assert_selector "h1", text: "Itds"
  end

  test "should create itd" do
    visit itds_url
    click_on "New itd"

    fill_in "P1", with: @itd.p1
    fill_in "P2", with: @itd.p2
    fill_in "P3", with: @itd.p3
    fill_in "P4", with: @itd.p4
    fill_in "P5", with: @itd.p5
    click_on "Create Itd"

    assert_text "Itd was successfully created"
    click_on "Back"
  end

  test "should update Itd" do
    visit itd_url(@itd)
    click_on "Edit this itd", match: :first

    fill_in "P1", with: @itd.p1
    fill_in "P2", with: @itd.p2
    fill_in "P3", with: @itd.p3
    fill_in "P4", with: @itd.p4
    fill_in "P5", with: @itd.p5
    click_on "Update Itd"

    assert_text "Itd was successfully updated"
    click_on "Back"
  end

  test "should destroy Itd" do
    visit itd_url(@itd)
    click_on "Destroy this itd", match: :first

    assert_text "Itd was successfully destroyed"
  end
end
