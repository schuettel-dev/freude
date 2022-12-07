require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "sign in" do
    visit new_session_path

    assert_selector "h1", text: "Sign in"

    fill_in "Token", with: "LUIGITOKEN"
    click_on "Join games"

    assert_selector "h1", text: "Dashboard"
    assert_selector "p", text: "Hi Luigi"
  end
end
