require "application_system_test_case"

class ItSrV1sTest < ApplicationSystemTestCase
  setup do
    @it_sr_v1 = it_sr_v1s(:one)
  end

  test "visiting the index" do
    visit it_sr_v1s_url
    assert_selector "h1", text: "It sr v1s"
  end

  test "should create it sr v1" do
    visit it_sr_v1s_url
    click_on "New it sr v1"

    fill_in "P1", with: @it_sr_v1.p1
    fill_in "P2", with: @it_sr_v1.p2
    fill_in "P3", with: @it_sr_v1.p3
    fill_in "P4", with: @it_sr_v1.p4
    fill_in "P5", with: @it_sr_v1.p5
    click_on "Create It sr v1"

    assert_text "It sr v1 was successfully created"
    click_on "Back"
  end

  test "should update It sr v1" do
    visit it_sr_v1_url(@it_sr_v1)
    click_on "Edit this it sr v1", match: :first

    fill_in "P1", with: @it_sr_v1.p1
    fill_in "P2", with: @it_sr_v1.p2
    fill_in "P3", with: @it_sr_v1.p3
    fill_in "P4", with: @it_sr_v1.p4
    fill_in "P5", with: @it_sr_v1.p5
    click_on "Update It sr v1"

    assert_text "It sr v1 was successfully updated"
    click_on "Back"
  end

  test "should destroy It sr v1" do
    visit it_sr_v1_url(@it_sr_v1)
    click_on "Destroy this it sr v1", match: :first

    assert_text "It sr v1 was successfully destroyed"
  end
end
