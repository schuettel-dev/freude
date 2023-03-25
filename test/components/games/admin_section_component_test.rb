require "test_helper"

class Games::AdminSectionComponentTest < ViewComponent::TestCase
  test "render, joining phase" do
    game = games(:beatle_mario_bros)
    user = users(:mario)
    render_inline new_component(game:, user:)

    assert_field "URL to join", with: "http://test.host/games/MARIOBROSURLIDENTIFIER/join/MARIOBROSJOINTOKEN"
    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "render, not joining phase" do
    game = games(:beatle_mario_bros)
    user = users(:mario)
    render_inline new_component(game:, user:)

    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "not render" do
    game = games(:beatle_mario_bros)
    user = users(:luigi)
    component = new_component(game:, user:)

    assert_not_predicate component, :render?
  end
end
