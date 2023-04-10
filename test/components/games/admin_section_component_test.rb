require "test_helper"

class Games::AdminSectionComponentTest < ViewComponent::TestCase
  test "render, collecting phase" do
    games(:beatle_seinfeld).collecting!
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_field "URL to join", with: "http://test.host/games/BEATLEJERRYURLIDENTIFIER/join/BEATLEJERRYJOINTOKEN"
    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "render, not collecting phase" do
    games(:beatle_seinfeld).guessing!
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_no_field "URL to join", with: "http://test.host/games/BEATLEJERRYURLIDENTIFIER/join/BEATLEJERRYJOINTOKEN"
    assert_link "Edit game"
    assert_button "Delete game"
  end

  test "not render" do
    player = players(:elaine_player_in_beatle_seinfeld)
    component = new_component(player:)

    assert_not_predicate component, :render?
  end
end
