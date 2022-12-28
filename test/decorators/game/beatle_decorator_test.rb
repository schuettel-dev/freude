require "test_helper"

class Game::BeatleDecoratorTest < ActiveSupport::TestCase
  test "#display_phase and #display_phase_description, phase :collecting" do
    game = Game::Beatle.new(phase: :collecting)

    assert_equal "Collecting", game.decorate.display_phase
    assert_equal "Players join and submit their songs.", game.decorate.display_phase_description
  end

  test "#display_phase and #display_phase_description, phase :guessing" do
    game = Game::Beatle.new(phase: :guessing)

    assert_equal "Guessing", game.decorate.display_phase
    assert_equal "Players listen to the others songs and guess who is behind.", game.decorate.display_phase_description
  end

  test "#display_phase and #display_phase_description, phase :ended" do
    game = Game::Beatle.new(phase: :ended)

    assert_equal "Ended", game.decorate.display_phase
    assert_equal "Final results and ranking.", game.decorate.display_phase_description
  end
end
