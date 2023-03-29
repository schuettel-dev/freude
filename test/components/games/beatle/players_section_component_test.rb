require "test_helper"

class Games::PlayersSectionComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:luigi_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_selector "li", count: 3
    assert_selector "li", text: "Luigi"
    assert_selector "li", text: "Mario"
    assert_selector "li", text: "Peach"
  end
end
