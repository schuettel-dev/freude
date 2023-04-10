require "test_helper"

class Games::GroupNameComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(game: games(:beatle_seinfeld))

    assert_selector "h1", text: "Seinfeld"
  end
end
