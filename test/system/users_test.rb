require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "sign up" do
    visit root_path

    assert_selector "h1", text: "Join the games"

    fill_in "Name", with: "Newman"
    click_on "Sign up"

    assert_selector "h1", text: "My games"
  end

  test "rejoin" do
    visit root_path

    fill_in "Name", with: "Babu"
    click_on "Sign up"
    sign_out
    click_on "Rejoin as Babu"

    assert_selector "h1", text: "My games"
  end
end
