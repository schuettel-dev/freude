require "test_helper"

class Games::PhaseDescriptionComponentTest < ViewComponent::TestCase
  test "render" do
    game = games(:beatle_mario_bros)
    user = users(:luigi)
    render_inline new_component(game:, user:)

    assert_selector "ol", count: 1
  end
end
