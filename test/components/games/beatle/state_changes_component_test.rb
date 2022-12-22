require "test_helper"

class Games::Beatle::StateChangesComponentTest < ViewComponent::TestCase
  test "render, state: :collecting" do
    game = games(:beatle_mario_bros)
    game.state = :collecting
    render_inline new_component(game:)

    assert_button "Proceed to Guessing phase"
  end

  test "render, state: :guessing" do
    skip "to be implemented"
  end

  test "render, state: :ended" do
    skip "to be implemented"
  end
end
