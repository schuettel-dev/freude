require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "GET index" do
    sign_in :jerry
    get games_path

    assert_response :success
  end

  test "GET show" do
    sign_in :jerry
    get game_path(games(:beatle_seinfeld))

    assert_response :success
  end

  test "GET new" do
    sign_in :jerry
    get new_game_path(game_template_id: game_templates(:beatle).to_param)

    assert_response :success
  end

  test "POST create" do
    sign_in :jerry

    assert_difference -> { Game.count }, +1 do
      post games_path(params: { game: { game_template_id: game_templates(:beatle).id, group_name: "Group name" } })
    end

    follow_redirect!

    assert_response :success
  end

  test "GET edit" do
    sign_in :jerry
    get edit_game_path(games(:beatle_seinfeld))

    assert_response :success
  end

  test "PUT update" do
    sign_in :jerry

    game = games(:beatle_seinfeld)

    assert_changes -> { game.group_name }, to: "Another group name" do
      put game_path(game), params: { game: { group_name: "Another group name" } }
      game.reload
    end

    follow_redirect!

    assert_response :success
  end

  test "DELETE destroy" do
    sign_in :jerry
    assert_difference -> { Game.count }, -1 do
      delete game_path(games(:beatle_seinfeld))
    end
    follow_redirect!

    assert_response :success
  end

  test "GET join" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :newman

    assert_difference -> { game.players.count }, +1 do
      get game_join_url(game, token: game.join_token, host: "www.example.com")
    end

    follow_redirect!

    assert_response :success
    assert_predicate game.players.find_by(user: users(:newman)).playlist, :present?
  end

  test "GET join, wrong token" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :newman

    assert_no_difference -> { game.players.count } do
      get game_join_url(game, token: "WRONGTOKEN", host: "www.example.com")
    end

    follow_redirect!

    assert_response :success
    assert_equal "Game couldn't be joined, the token was wrong.", flash[:notice]
  end

  test "GET join, already joined" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    sign_in :kramer

    assert_no_difference -> { game.players.count } do
      get game_join_url(game, token: game.join_token, host: "www.example.com")
    end

    follow_redirect!

    assert_response :success
  end

  test "DELETE leave" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    sign_in :kramer

    assert_difference -> { game.players.count }, -1 do
      delete game_leave_path(game)
    end

    follow_redirect!

    assert_response :success
  end

  test "not DELETE leave, if phase not collecting" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)

    sign_in :kramer

    assert_raises(Pundit::NotAuthorizedError) do
      delete game_leave_path(game)
    end
  end

  test "DELETE leave, game where not player" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    sign_in :newman

    assert_raises(ActiveRecord::RecordNotFound) do
      delete game_leave_path(game)
    end
  end

  test "DELETE leave, admin cannot leave" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    sign_in :jerry

    assert_raises(Pundit::NotAuthorizedError) do
      delete game_leave_path(game)
    end
  end
end
