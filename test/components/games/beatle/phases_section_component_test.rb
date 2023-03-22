require "test_helper"

class Games::PhasesSectionComponentTest < ViewComponent::TestCase
  test "render, collecting" do
    user = users(:luigi)
    game = games(:beatle_mario_bros)
    render_inline new_component(game:, user:)

    assert_current_phase "Collecting"
  end

  test "render, guessing" do
    user = users(:luigi)
    game = games(:beatle_mario_bros)
    game.phase = :guessing
    render_inline new_component(game:, user:)

    assert_current_phase "Guessing"
  end

  test "render, ended" do
    user = users(:luigi)
    game = games(:beatle_mario_bros)
    game.phase = :ended
    render_inline new_component(game:, user:)

    assert_selector "[title='Current']", count: 0
  end

  private

  def assert_current_phase(phase)
    assert_selector "[title='Current']" do |element|
      element.ancestor("summary").has_text?(phase)
    end
  end
end
