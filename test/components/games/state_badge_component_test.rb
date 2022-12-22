require "test_helper"

class Games::StateBadgeComponentTest < ViewComponent::TestCase
  test "render, state: :collecting" do
    render_inline new_component(game: Game::Beatle.new(state: :collecting))

    assert_selector ".games--state-badge", text: "Collecting"
  end

  test "render, state: :guessing" do
    render_inline new_component(game: Game::Beatle.new(state: :guessing))

    assert_selector ".games--state-badge", text: "Guessing"
  end

  test "render, state: :ended" do
    render_inline new_component(game: Game::Beatle.new(state: :ended))

    assert_selector ".games--state-badge", text: "Ended"
  end
end
