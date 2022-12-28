require "test_helper"

class Games::Beatle::PhaseChangesComponentTest < ViewComponent::TestCase
  test "render, phase: :collecting" do
    game = games(:beatle_mario_bros)
    game.phase = :collecting
    render_inline new_component(game:)

    assert_button "Proceed to Guessing phase"
  end

  test "render, phase: :guessing" do
    skip "to be implemented"
  end

  test "render, phase: :ended" do
    skip "to be implemented"
  end
end
