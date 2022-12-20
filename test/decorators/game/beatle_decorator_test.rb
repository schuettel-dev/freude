require "test_helper"

class Game::BeatleDecoratorTest < ActiveSupport::TestCase
  test "#display_state and #display_state_description, state :collecting" do
    game = Game::Beatle.new(state: :collecting)

    assert_equal "Collecting", game.decorate.display_state
    assert_equal "Players join and submit their songs.", game.decorate.display_state_description
  end

  test "#display_state and #display_state_description, state :guessing" do
    game = Game::Beatle.new(state: :guessing)

    assert_equal "Guessing", game.decorate.display_state
    assert_equal "Players listen to the others songs and guess who is behind.", game.decorate.display_state_description
  end

  test "#display_state and #display_state_description, state :ended" do
    game = Game::Beatle.new(state: :ended)

    assert_equal "Ended", game.decorate.display_state
    assert_equal "Final results and ranking.", game.decorate.display_state_description
  end
end
