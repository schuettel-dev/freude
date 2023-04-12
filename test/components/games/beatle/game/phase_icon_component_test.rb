require "test_helper"

class Games::Beatle::Game::PhaseIconComponentTest < ViewComponent::TestCase
  test "render, collecting phase, collecting current" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    render_inline new_component(game:, phase: :collecting)

    assert_selector "[title='Current']", count: 1
  end

  test "render, guessing phase, collecting completed" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)
    render_inline new_component(game:, phase: :collecting)

    assert_selector "[title='Completed']", count: 1
  end
end
