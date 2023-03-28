require "test_helper"

class Games::Beatle::PlaylistGuessTest < ActiveSupport::TestCase
  test "validates" do
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).dup
    playlist_guess.points = 2

    assert_not_predicate playlist_guess, :valid?

    playlist_guess.errors.to_a.tap do |errors|
      assert_includes errors, "Points is not included in the list"
      assert_includes errors, "Guessing player has already been taken"
    end
  end
end
