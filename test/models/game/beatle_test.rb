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
    game.phase = :collecting

    assert game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :guessing" do
    game = games(:beatle_mario_bros)
    game.phase = :guessing

    assert game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :ended" do
    game = games(:beatle_mario_bros)
    game.phase = :ended

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#minimal_requirements_met_for_phase?, :guessing" do
    skip "to be implemented"
  end

  test "#minimal_requirements_met_for_phase?, :ended" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :collecting, to: :guessing" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :guessing, to: :ended" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :guessing, to: :collecting" do
    skip "to be implemented"
  end
end
