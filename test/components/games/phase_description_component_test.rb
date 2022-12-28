require "test_helper"

class Games::PhaseDescriptionComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(game: games(:beatle_mario_bros))

    assert_selector "ol", count: 1
  end
end
