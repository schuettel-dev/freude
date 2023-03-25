require "test_helper"

class Games::Beatle::PhasesControllerTest < ActionDispatch::IntegrationTest
  test "from collecting to collecting" do
    game = games(:beatle_seinfeld)
    game.collecting!

    sign_in :jerry

    assert_no_changes -> { game.reload.phase } do
      patch game_phase_path(game), params: { phase: "collecting" }
    end

    follow_redirect!

    assert_response :success
  end

  test "from collecting to guessing" do
    game = games(:beatle_seinfeld)
    game.collecting!
    game.playlist_guesses.delete_all

    sign_in :jerry

    assert_changes -> { game.playlist_guesses.reload.count }, from: 0 do
      assert_changes -> { game.reload.phase }, to: "guessing" do
        patch game_phase_path(game), params: { phase: "guessing" }
      end
    end

    follow_redirect!

    assert_response :success
  end

  test "from collecting to ended" do
    game = games(:beatle_seinfeld)
    game.collecting!

    sign_in :jerry

    assert_no_changes -> { game.reload.phase } do
      patch game_phase_path(game), params: { phase: "ended" }
    end

    follow_redirect!

    assert_response :success
  end

  test "from guessing to collecting" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    sign_in :jerry

    assert_no_changes -> { playlist_guess.reload.guessed_player } do
      assert_changes -> { game.reload.phase }, to: "collecting" do
        patch game_phase_path(game), params: { phase: "collecting" }
      end
    end

    follow_redirect!

    assert_response :success
  end

  test "from guessing to guessing" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    sign_in :jerry

    assert_no_changes -> { playlist_guess.reload.guessed_player } do
      assert_no_changes -> { game.reload.phase } do
        patch game_phase_path(game), params: { phase: "guessing" }
      end
    end

    follow_redirect!

    assert_response :success
  end

  test "from guessing to ended" do
    skip "TODO"
  end

  test "from ended to ended" do
    skip "TODO"
  end

  test "from ended to collecting" do
    skip "TODO"
  end

  test "from ended to guessing" do
    skip "TODO"
  end
end
