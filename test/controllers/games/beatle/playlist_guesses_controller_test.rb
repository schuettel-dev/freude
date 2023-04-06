require "test_helper"

class Games::Beatle::PlaylistsGuessesControllerTest < ActionDispatch::IntegrationTest
  # GET
  test "GET edit" do
    game = games(:beatle_seinfeld)
    game.guessing!
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    sign_in :jerry

    get edit_game_beatle_playlist_guess_path(game, playlist_guess)
    assert_response :success
  end

  test "not GET edit, not guessing phase" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    sign_in :jerry

    assert_raises(Pundit::NotAuthorizedError) do
      get edit_game_beatle_playlist_guess_path(game, playlist_guess)
    end
  end

  test "not GET edit, not owner of playlist guess" do
    game = games(:beatle_seinfeld)
    game.guessing!
    playlist_guess = games_beatle_playlist_guesses(:elaine_player_in_beatle_seinfeld_guessing_jerry)

    sign_in :jerry

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_game_beatle_playlist_guess_path(game, playlist_guess)
    end
  end

  # PUT
  test "PUT update" do
    game = games(:beatle_seinfeld)
    game.guessing!
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    other_player = players(:george_player_in_beatle_seinfeld)

    sign_in :jerry

    assert_changes -> { playlist_guess.reload.guessed_player }, to: other_player do
      put game_beatle_playlist_guess_path(game, playlist_guess), params: {
        games_beatle_playlist_guess: {
          guessed_player_id: other_player.id
        }
      }
    end

    follow_redirect!
    assert_response :success
  end

  test "not PUT update, not guessing phase" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    sign_in :jerry

    assert_raises(Pundit::NotAuthorizedError) do
      put game_beatle_playlist_guess_path(game, playlist_guess), params: {}
    end
  end

  test "not PUT update, not player of playlist guess" do
    game = games(:beatle_seinfeld)
    game.guessing!
    playlist_guess = games_beatle_playlist_guesses(:elaine_player_in_beatle_seinfeld_guessing_jerry)

    sign_in :jerry

    assert_raises(ActiveRecord::RecordNotFound) do
      put game_beatle_playlist_guess_path(game, playlist_guess), params: {}
    end
  end
end
