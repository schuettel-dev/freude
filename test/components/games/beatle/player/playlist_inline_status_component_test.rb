require "test_helper"

class Games::Beatle::Playlist::InlineStatusComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:mario_player_in_beatle_mario_bros)
    render_inline new_component(playlist:)

    assert_selector "svg", count: 3
  end
end
