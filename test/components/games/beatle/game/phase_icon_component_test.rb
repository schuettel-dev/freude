require "test_helper"

class Games::Beatle::Game::PhaseIconComponentTest < ViewComponent::TestCase
  test "render, game collecting, current" do
    game = games(:beatle_seinfeld)
    game.collecting!
    render_inline new_component(game:, phase: :collecting)

    assert_selector "[title='Current']", count: 1
  end

  test "render, game collecting against guessing, blocked" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)
    render_inline new_component(game:, phase: :guessing)

    assert_selector "[title='Blocked']", count: 1
  end

  test "render, game collecting against guessing, proceed" do
    game = games(:beatle_seinfeld)
    game.collecting!
    render_inline new_component(game:, phase: :guessing)

    assert_selector "[title='Proceed']", count: 1
  end

  test "render, game guessing against ended" do
    game = games(:beatle_seinfeld)
    game.guessing!
    render_inline new_component(game:, phase: :ended)

    assert_selector "[title='Proceed']", count: 1
  end

  test "render, game ended" do
    game = games(:beatle_seinfeld)
    render_inline new_component(game:, phase: :irrelevant)

    assert_selector "[title='Completed']", count: 1
  end
end
