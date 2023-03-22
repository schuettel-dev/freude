require "test_helper"

class Games::Beatle::Game::PhaseTransitionComponentTest < ViewComponent::TestCase
  test "not render, if not owner" do
    game = games(:beatle_mario_bros)
    phase = :irrelevant
    user = users(:luigi)
    component = new_component(game:, phase:, user:)

    assert_not component.render?
  end

  test "not render, current phase" do
    game = games(:beatle_mario_bros)
    phase = :collecting
    user = users(:mario)
    component = new_component(game:, phase:, user:)

    assert_not component.render?
  end

  test "not render, transition not allowed" do
    game = games(:beatle_mario_bros)
    phase = :ended
    user = users(:mario)
    component = new_component(game:, phase:, user:)

    assert_not component.render?
  end

  test "render, transition back" do
    game = games(:beatle_seinfeld)
    phase = :collecting
    user = users(:jerry)
    render_inline new_component(game:, phase:, user:)

    assert_selector "button", text: "Go back to this phase"
    assert_text "All data from this state will be lost"
  end

  test "render, transition forward, blocked" do
    game = games(:beatle_mario_bros)
    phase = :guessing
    user = users(:mario)
    render_inline new_component(game:, phase:, user:)

    assert false, "TODO"
  end

  test "render, transition forward, proceed" do
    game = games(:beatle_seinfeld)
    game.collecting!
    phase = :guessing
    user = users(:jerry)
    render_inline new_component(game:, phase:, user:)

    assert false, "TODO"
  end
end
