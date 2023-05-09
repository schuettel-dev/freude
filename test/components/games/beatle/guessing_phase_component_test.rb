require "test_helper"

class Games::Beatle::GuessingPhaseComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "h2", text: "Who's behind this playlist?"
    assert_selector "h2", text: "My playlist"
  end
end
