require "test_helper"

class Games::Beatle::EndedPhaseComponentTest < ViewComponent::TestCase
  test "render" do
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "h2", text: "Final ranking"
    assert_selector "h2", text: "Final results"
  end
end
