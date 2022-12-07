require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "sign up" do
    visit root_path

    assert_selector "h1", text: "Join"

    fill_in "Name", with: "Toad"
    click_on "Join games"

    assert_selector "h1", text: "Dashboard"
    assert_selector "p", text: "Hi Toad"
  end
end
