require "application_system_test_case"

class ProfileTest < ApplicationSystemTestCase
  test "user changes name and color" do
    sign_in :jerry
    navigate_to "Profile"
    click_on "Edit"
    fill_in "Name", with: "Jeremy"
    fill_in "Color", with: "#ff00ff"
    click_on "Update profile"

    assert_description_list "Name", "Jeremy"
    assert_selector "span", style: "background-color: #ff00ff;"
  end
end
