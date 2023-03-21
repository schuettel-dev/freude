require "test_helper"

class Games::Beatle::PlayerTest < ActiveSupport::TestCase
  test "save" do
    user = users(:toad)
    game = games(:beatle_mario_bros)

    player = Games::Beatle::Player.new(user:, game:)

    assert_difference -> { game.players.count }, +1 do
      assert player.save!
    end

    assert_equal "Games::Beatle::Player", player.type
  end
end
