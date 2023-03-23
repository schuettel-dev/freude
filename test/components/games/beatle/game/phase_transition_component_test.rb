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

    assert_selector "button", text: "Return to this phase"
    assert_text "All data from this phase will be lost"
  end

  test "render, transition forward, blocked" do
    game = games(:beatle_mario_bros)
    phase = :guessing
    user = users(:mario)
    render_inline new_component(game:, phase:, user:)

    assert_selector "button", text: "Start this phase" do |element|
      assert element[:disabled]
    end
    assert_text "This phase can't be started yet. Make sure enough players have submitted their songs."
  end

  test "render, transition forward, proceed" do
    game = games(:beatle_seinfeld)
    game.collecting!
    phase = :guessing
    user = users(:jerry)
    render_inline new_component(game:, phase:, user:)

    assert_selector "button", text: "Start this phase"
  end
end
