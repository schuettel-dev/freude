require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET new" do
    get new_session_path

    assert_response :success
  end

  test "GET new, already signed in" do
    sign_in :mario
    get new_session_path

    assert_redirected_to(root_path)
    follow_redirect!

    assert_response :success
  end

  test "POST create" do
    sign_in :mario

    assert_routing "/", controller: "dashboard", action: "show"
  end

  test "POST create, invalid params" do
    post session_path, params: { session: { token: "" } }

    assert_predicate session, :empty?
    assert_response :unprocessable_entity
  end

  test "POST create, wrong token" do
    post session_path, params: { session: { token: "INVALIDTOKEN" } }

    assert_predicate session, :empty?
    assert_response :unprocessable_entity
  end

  test "DELETE destroy" do
    sign_in :mario
    delete session_path

    assert_redirected_to(new_sign_up_path)
    follow_redirect!

    assert_response :success
  end

  test "DELETE destroy, not signed in" do
    delete session_path

    assert_redirected_to(new_sign_up_path)
    follow_redirect!

    assert_response :success
  end
end
