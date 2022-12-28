require "test_helper"

class Games::Beatle::PhaseDescriptionComponentTest < ViewComponent::TestCase
  test "render, collecting" do
    render_inline new_component(game: games(:beatle_mario_bros))

    assert_selector "details[open]", text: "Collecting"
  end

  test "render, guessing" do
    game = games(:beatle_mario_bros)
    game.phase = :guessing
    render_inline new_component(game:)

    assert_selector "details[open]", text: "Guessing"
  end

  test "render, ended" do
    game = games(:beatle_mario_bros)
    game.phase = :ended
    render_inline new_component(game:)

    assert_selector "details[open]", text: "Ended"
  end
end
