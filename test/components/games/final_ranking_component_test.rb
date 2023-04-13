require "test_helper"

class Games::FinalRankingComponentTest < ViewComponent::TestCase
  test "render, all: false" do
    game = games(:beatle_seinfeld)
    highlight_player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(game:, highlight_player:)

    assert_selector "h3", text: "Your ranking"
    assert_text "Laney"
    assert_text "Jerry"
    assert_text "Kramer"
    assert_no_text "George"
    assert_no_link "Show less"
    assert_link "Show more"
  end

  test "render, all: true" do
    game = games(:beatle_seinfeld)
    highlight_player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(game:, highlight_player:, all: true)

    assert_selector "h3", text: "Your ranking"
    assert_text "Laney"
    assert_text "Jerry"
    assert_text "Kramer"
    assert_text "George"
    assert_link "Show less"
    assert_no_link "Show more"
  end

  test "render, no fourth place" do
    game = games(:beatle_seinfeld)
    players(:george_player_in_beatle_seinfeld).update_column(:final_rank, 3)
    highlight_player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(game:, highlight_player:, all: true)

    assert_selector "h3", text: "Your ranking"
    assert_text "Laney"
    assert_text "Jerry"
    assert_text "Kramer"
    assert_text "George"
    assert_no_link "Show less"
    assert_no_link "Show more"
  end
end
