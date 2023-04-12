require "test_helper"

class Games::Beatle::Game::TransitionAllowedTest < ActiveSupport::TestCase
  test ".transition_allowed?, from_phase: nil" do
    assert Games::Beatle::Game.transition_allowed?(to_phase: :collecting)
    assert_not Games::Beatle::Game.transition_allowed?(to_phase: :guessing)
    assert_not Games::Beatle::Game.transition_allowed?(to_phase: :ended)
  end

  test ".transition_allowed?, from_phase: :collecting" do
    from_phase = :collecting
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :collecting)
    assert Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :guessing)
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :ended)
  end

  test ".transition_allowed?, from_phase: :guessing" do
    from_phase = :guessing
    assert Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :collecting)
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :guessing)
    assert Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :ended)
  end

  test ".transition_allowed?, from_phase: :ended" do
    from_phase = :ended
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :collecting)
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :guessing)
    assert_not Games::Beatle::Game.transition_allowed?(from_phase:, to_phase: :ended)
  end

  test "#transition_allowed?, phase: :collecting" do
    game = games(:beatle_seinfeld)
    game.phase = :collecting

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, phase: :guessing" do
    game = games(:beatle_seinfeld)
    game.phase = :guessing

    assert game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, phase: :ended" do
    game = games(:beatle_seinfeld)
    game.phase = :ended

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end
end
