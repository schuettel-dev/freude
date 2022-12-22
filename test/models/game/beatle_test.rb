require "test_helper"

class Game::BeatleTest < ActiveSupport::TestCase
  test "#minimum_players_reached?" do
    game = games(:beatle_mario_bros)

    assert_changes -> { game.minimum_players_reached? }, to: false do
      game.players.excluding(
        players(:mario_player_in_beatle_mario_bros, :luigi_player_in_beatle_mario_bros)
      ).destroy_all
    end
  end

  test "#transition_allowed?, from: :collecting" do
    game = games(:beatle_mario_bros)
    game.state = :collecting

    assert game.transition_allowed?(to_state: :collecting)
    assert game.transition_allowed?(to_state: :guessing)
    assert_not game.transition_allowed?(to_state: :ended)
  end

  test "#transition_allowed?, from: :guessing" do
    game = games(:beatle_mario_bros)
    game.state = :guessing

    assert game.transition_allowed?(to_state: :collecting)
    assert game.transition_allowed?(to_state: :guessing)
    assert game.transition_allowed?(to_state: :ended)
  end

  test "#transition_allowed?, from: :ended" do
    game = games(:beatle_mario_bros)
    game.state = :ended

    assert_not game.transition_allowed?(to_state: :collecting)
    assert_not game.transition_allowed?(to_state: :guessing)
    assert game.transition_allowed?(to_state: :ended)
  end
end
