require "test_helper"

class Games::PlayersSectionComponentTest < ViewComponent::TestCase
  test "render" do
    game = games(:beatle_mario_bros)
    user = users(:luigi)
    render_inline new_component(game:, user:)

    assert_selector "li", count: 3
    assert_selector "li", text: "Luigi"
    assert_selector "li", text: "Mario"
    assert_selector "li", text: "Peach"
  end
end
