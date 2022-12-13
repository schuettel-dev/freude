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
    skip "to be implemented"

    sign_in :mario
    get edit_game_path(games(:beatle_mario_bros))

    assert_response :success
  end

  test "PUT update" do
    skip "to be implemented"

    sign_in :mario
    put game_path(games(:beatle_mario_bros))
    follow_redirect!

    assert_response :success
  end

  test "DELETE destroy" do
    skip "to be implemented"

    sign_in :mario
    delete game_path(games(:beatle_mario_bros))
    follow_redirect!

    assert_response :success
  end
end
