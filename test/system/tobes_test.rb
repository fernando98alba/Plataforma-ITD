require "application_system_test_case"

class TobesTest < ApplicationSystemTestCase
  setup do
    @tobe = tobes(:one)
  end

  test "visiting the index" do
    visit tobes_url
    assert_selector "h1", text: "Tobes"
  end

  test "should create tobe" do
    visit tobes_url
    click_on "New tobe"

    fill_in "Capitalestrategico", with: @tobe.capitalestrategico
    fill_in "Capitalestructural", with: @tobe.capitalestructural
    fill_in "Capitalhumano", with: @tobe.capitalhumano
    fill_in "Capitalnatural", with: @tobe.capitalnatural
    fill_in "Capitalrelacional", with: @tobe.capitalrelacional
    click_on "Create Tobe"

    assert_text "Tobe was successfully created"
    click_on "Back"
  end

  test "should update Tobe" do
    visit tobe_url(@tobe)
    click_on "Edit this tobe", match: :first

    fill_in "Capitalestrategico", with: @tobe.capitalestrategico
    fill_in "Capitalestructural", with: @tobe.capitalestructural
    fill_in "Capitalhumano", with: @tobe.capitalhumano
    fill_in "Capitalnatural", with: @tobe.capitalnatural
    fill_in "Capitalrelacional", with: @tobe.capitalrelacional
    click_on "Update Tobe"

    assert_text "Tobe was successfully updated"
    click_on "Back"
  end

  test "should destroy Tobe" do
    visit tobe_url(@tobe)
    click_on "Destroy this tobe", match: :first

    assert_text "Tobe was successfully destroyed"
  end
end
