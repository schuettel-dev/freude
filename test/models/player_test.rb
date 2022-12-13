require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "save" do
    user = users(:toad)
    game = games(:beatle_mario_bros)

    player = Player.new(user:, game:)

    assert_difference -> { game.players.count }, +1 do
      assert player.save!
    end
  end
end
