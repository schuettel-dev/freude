require "test_helper"

class Games::Beatle::PlayersSectionComponentTest < ViewComponent::TestCase
  test "render" do
    games(:beatle_seinfeld).guessing!

    player = players(:elaine_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "li", count: 4
    assert_selector "li", text: "Jerry"
    assert_selector "li", text: "Laney"
    assert_selector "li", text: "George"
    assert_selector "li", text: "Kramer"
  end

  test "not render" do
    games(:beatle_seinfeld).ended!
    player = players(:elaine_player_in_beatle_seinfeld)

    assert_not_predicate new_component(player:), :render?
  end
end
