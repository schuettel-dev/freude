require "test_helper"

class Games::AdminSectionComponentTest < ViewComponent::TestCase
  test "render, joining phase" do
    player = players(:mario_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_field "URL to join", with: "http://test.host/games/MARIOBROSURLIDENTIFIER/join/MARIOBROSJOINTOKEN"
    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "render, not joining phase" do
    player = players(:mario_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "not render" do
    player = players(:luigi_player_in_beatle_mario_bros)
    component = new_component(player:)

    assert_not_predicate component, :render?
  end
end
