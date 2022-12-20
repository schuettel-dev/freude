require "test_helper"

class Game::BeatlePolicyTest < ActiveSupport::TestCase
  test "#join?" do
    assert_permit users(:toad), games(:beatle_mario_bros), :join?
  end

  test "not #join?, state :guessing" do
    game = games(:beatle_mario_bros)
    game.state = :guessing

    assert_not_permit users(:toad), game, :join?
  end

  test "not #join?, state :ended" do
    game = games(:beatle_mario_bros)
    game.state = :ended

    assert_not_permit users(:toad), game, :join?
  end
end
