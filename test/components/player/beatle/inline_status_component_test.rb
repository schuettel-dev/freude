require "test_helper"

class Player::Beatle::InlineStatusComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:mario_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_selector "svg", count: 3
  end
end
