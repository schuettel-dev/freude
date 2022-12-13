require "test_helper"

class GameTemplates::InstancesControllerTest < ActionDispatch::IntegrationTest
  test "GET new" do
    sign_in :mario
    get new_game_template_instance_path(game_templates(:beatle))

    assert_response :success
  end

  test "POST create" do
    sign_in :mario

    assert_difference -> { Game.count }, +1 do
      post game_template_instance_path(game_templates(:beatle)), params: { game: { group_name: "Group name" } }
    end

    follow_redirect!

    assert_response :success
  end
end
