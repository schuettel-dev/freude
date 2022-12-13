require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "GET index" do
    sign_in :mario
    get games_path

    assert_response :success
  end

  test "GET show" do
    sign_in :mario
    get game_path(games(:beatle_mario_bros))

    assert_response :success
  end

  test "GET edit" do
    sign_in :mario
    get edit_game_path(games(:beatle_mario_bros))

    assert_response :success
  end

  test "PUT update" do
    sign_in :mario

    game = games(:beatle_mario_bros)

    assert_changes -> { game.group_name }, to: "Another group name" do
      put game_path(game), params: { game: { group_name: "Another group name" } }
      game.reload
    end

    follow_redirect!

    assert_response :success
  end

  test "DELETE destroy" do
    sign_in :mario
    assert_difference -> { Game.count }, -1 do
      delete game_path(games(:beatle_mario_bros))
    end
    follow_redirect!

    assert_response :success
  end
end
