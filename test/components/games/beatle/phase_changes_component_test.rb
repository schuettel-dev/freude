require "test_helper"

class Games::Beatle::PhaseChangesComponentTest < ViewComponent::TestCase
  test "not render, not owner" do
    game = games(:beatle_mario_bros)
    user = users(:luigi)
    component = new_component(game:, user:)

    assert_not_predicate component, :render?
  end

  test "render, phase: :collecting" do
    skip "to be implemented"

    game = games(:beatle_mario_bros)
    user = users(:mario)
    game.phase = :collecting
    render_inline new_component(game:, user:)

    assert_button "Proceed to Guessing phase"
  end

  test "render, phase: :guessing" do
    skip "to be implemented"
  end

  test "render, phase: :ended" do
    skip "to be implemented"
  end
end
