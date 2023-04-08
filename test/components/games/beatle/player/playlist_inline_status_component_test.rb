require "test_helper"

class Games::Beatle::Player::PlaylistInlineStatusComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "svg", count: 3
  end
end
