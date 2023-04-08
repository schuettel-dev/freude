require "test_helper"

class Players::FinalRankComponentTest < ViewComponent::TestCase
  test "render, 1st, size: lg" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.final_rank = 1
    render_inline new_component(player:, size: :lg)

    assert_selector "span", text: "1st", class: "text-lg w-16 h-16 bg-yellow-400"
  end

  test "render, 2nd, size: default" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.final_rank = 2
    render_inline new_component(player:)

    assert_selector "span", text: "2nd", class: "text-xs w-8 h-8 bg-zinc-300"
  end

  test "render, 3rd" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.final_rank = 3
    render_inline new_component(player:)

    assert_selector "span", text: "3rd", class: "bg-amber-700 text-white"
  end

  test "render, 4th" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.final_rank = 4
    render_inline new_component(player:)

    assert_selector "span", text: "4th", class: "bg-gray-200"
  end

  test "render, 999th" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.final_rank = 999
    render_inline new_component(player:)

    assert_selector "span", text: "999th", class: "bg-gray-200"
  end
end
