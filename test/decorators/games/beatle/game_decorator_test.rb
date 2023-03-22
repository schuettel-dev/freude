require "test_helper"

class Games::Beatle::GameDecoratorTest < ActiveSupport::TestCase
  test "#display_phase and #display_phase_description, phase :collecting" do
    game = Games::Beatle::Game.new(phase: :collecting)

    assert_equal "Collecting", game.decorate.display_phase
    assert_equal "Players join and submit their songs.", game.decorate.display_phase_description
  end

  test "#display_phase and #display_phase_description, phase :guessing" do
    game = Games::Beatle::Game.new(phase: :guessing)

    assert_equal "Guessing", game.decorate.display_phase
    assert_equal "Players listen to the others songs and guess who is behind.", game.decorate.display_phase_description
  end

  test "#display_phase and #display_phase_description, phase :ended" do
    game = Games::Beatle::Game.new(phase: :ended)

    assert_equal "Ended", game.decorate.display_phase
    assert_equal "Final results and ranking.", game.decorate.display_phase_description
  end
end
