require "test_helper"

class GameTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "GET index" do
    sign_in :mario
    get game_templates_path

    assert_response :success
  end
end
