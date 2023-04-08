require "test_helper"

class Games::Beatle::PlaylistGuessPolicyTest < ActiveSupport::TestCase
  test "edit?" do
    game = games(:beatle_seinfeld)
    game.guessing!
    user = users(:jerry)
    other_user = users(:george)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    assert_permit user, playlist_guess, :edit?
    assert_not_permit other_user, playlist_guess, :edit?

    game.collecting!
    playlist_guess.reload

    assert_not_permit user, playlist_guess, :edit?

    game.ended!
    playlist_guess.reload

    assert_not_permit user, playlist_guess, :edit?
  end
end
