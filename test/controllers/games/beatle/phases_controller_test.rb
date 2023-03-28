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
    game.guessing!
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
    game = games(:beatle_seinfeld)
    game.guessing!

    player = players(:jerry_player_in_beatle_seinfeld)
    player.update!(final_points: nil, final_rank: nil)

    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_george)
    playlist_guess.update!(points: 0)

    sign_in :jerry

    assert_changes -> { player.reload.final_rank }, to: 2 do
      assert_changes -> { player.reload.final_points }, to: 1 do
        assert_changes -> { playlist_guess.reload.points }, to: 1 do
          assert_changes -> { game.reload.phase }, to: "ended" do
            patch game_phase_path(game), params: { phase: "ended" }
          end
        end
      end
    end

    follow_redirect!

    assert_response :success
  end

  test "from ended to ended" do
    assert_game_remains_unchanged(to_phase: "ended")
  end

  test "from ended to collecting" do
    assert_game_remains_unchanged(to_phase: "collecting")
  end

  test "from ended to guessing" do
    assert_game_remains_unchanged(to_phase: "guessing")
  end

  private

  def assert_game_remains_unchanged(to_phase:)
    game = games(:beatle_seinfeld)

    player = players(:jerry_player_in_beatle_seinfeld)
    player.update!(final_rank: 99)

    sign_in :jerry

    assert_no_changes -> { game.reload.phase } do
      patch game_phase_path(game), params: { phase: to_phase }
    end

    follow_redirect!

    assert_response :success
    assert_equal 99, player.reload.final_rank
  end
end
