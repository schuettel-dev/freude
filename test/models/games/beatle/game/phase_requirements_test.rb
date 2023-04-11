require "test_helper"

class Games::Beatle::Game::PhaseRequirementsTest < ActiveSupport::TestCase
  # to collecting
  test "transition to collecting, valid" do
    game = games(:beatle_seinfeld)
    game.phase = :collecting

    assert_predicate game, :valid?
  end

  # to guessing
  test "transition to guessing, valid" do
    game = games(:beatle_seinfeld)
    game.phase = :guessing

    assert_predicate game, :valid?
  end

  test "transition to guessing, invalid" do
    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)

    game = games(:beatle_seinfeld)
    game.phase = :guessing

    assert_not_predicate game, :valid?

    game.errors.to_a.tap do |errors|
      assert_equal 2, errors.count
      assert_includes errors, "There aren't enough players."
      assert_includes errors, "Not enough players have guessed playlists."
    end
  end

  # to ended
  test "transition to ended, valid" do
    game = games(:beatle_seinfeld)
    game.guessing!
    game.phase = :ended

    assert_predicate game, :valid?
  end

  test "transition to ended, invalid" do
    games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).update!(guessed_player: nil)
    game = games(:beatle_seinfeld)
    game.guessing!
    game.phase = :ended

    assert_not_predicate game, :valid?

    game.errors.to_a.tap do |errors|
      assert_equal 1, errors.count
      assert_includes errors, "Not all players have casted alle their guesses."
    end
  end
end
