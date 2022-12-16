require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def sign_in(user_fixture_key)
    visit new_session_path
    fill_in "Token", with: users(user_fixture_key).token
    click_on "Join games"
  end

  def sign_out
    click_on "Sign out"
  end
end
