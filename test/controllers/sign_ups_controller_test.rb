require "test_helper"

class SignUpsControllerTest < ActionDispatch::IntegrationTest
  test "GET new" do
    get new_sign_up_path

    assert_response :success
  end

  test "GET new, redirected when already signed in" do
    sign_in :mario
    get new_sign_up_path

    assert_redirected_to(root_path)
    follow_redirect!

    assert_response :success
  end

  test "POST create" do
    assert_difference -> { User.count }, +1 do
      post sign_up_path, params: { user: { name: "Peach" } }
    end

    follow_redirect!

    assert_response :success
  end

  test "POST create, invalid params" do
    assert_no_difference -> { User.count } do
      post sign_up_path, params: { user: { name: "" } }
    end

    assert_response :unprocessable_entity
  end
end
