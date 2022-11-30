require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "GET show, redirect to sign up if not signed in" do
    get root_path
    assert_redirected_to(new_sign_up_path)
    follow_redirect!
    assert_response :success
  end

  test "GET show" do
    sign_in :mario
    get root_path
    assert_response :success
  end
end
