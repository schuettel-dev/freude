require "test_helper"

class Games::GroupNameComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(game: games(:beatle_mario_bros))
    assert_selector "h1", text: "Mario Bros"
  end
end
