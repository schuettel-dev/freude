require "test_helper"

class Games::Beatle::StateDescriptionComponentTest < ViewComponent::TestCase
  test "render, collecting" do
    render_inline new_component(game: games(:beatle_mario_bros))

    assert_selector "li", text: "Players join"
    assert_selector "li", text: "Players listen", class: "text-gray-400"
    assert_selector "li", text: "Final", class: "text-gray-400"
    assert_selector ".text-gray-400", count: 2
  end

  test "render, guessing" do
    game = games(:beatle_mario_bros)
    game.state = :guessing
    render_inline new_component(game:)

    assert_selector "li", text: "Players join"
    assert_selector "li", text: "Players listen"
    assert_selector "li", text: "Final", class: "text-gray-400"
    assert_selector ".text-gray-400", count: 1
  end

  test "render, ended" do
    game = games(:beatle_mario_bros)
    game.state = :ended
    render_inline new_component(game:)

    assert_selector "li", text: "Players join"
    assert_selector "li", text: "Players listen"
    assert_selector "li", text: "Final"
    assert_selector ".text-gray-400", count: 0
  end
end
