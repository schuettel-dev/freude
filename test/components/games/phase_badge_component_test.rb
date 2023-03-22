require "test_helper"

class Games::PhaseBadgeComponentTest < ViewComponent::TestCase
  test "render, phase: :collecting" do
    render_inline new_component(game: Games::Beatle::Game.new(phase: :collecting))

    assert_selector ".games--phase-badge", text: "Collecting"
  end

  test "render, phase: :guessing" do
    render_inline new_component(game: Games::Beatle::Game.new(phase: :guessing))

    assert_selector ".games--phase-badge", text: "Guessing"
  end

  test "render, phase: :ended" do
    render_inline new_component(game: Games::Beatle::Game.new(phase: :ended))

    assert_selector ".games--phase-badge", text: "Ended"
  end
end
