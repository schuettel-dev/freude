require "test_helper"

class Games::PhasesSectionComponentTest < ViewComponent::TestCase
  test "render, collecting" do
    player = players(:luigi_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_current_phase "Collecting"
  end

  test "render, guessing" do
    games(:beatle_mario_bros).guessing!
    player = players(:luigi_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_current_phase "Guessing"
  end

  test "render, ended" do
    games(:beatle_mario_bros).ended!
    player = players(:luigi_player_in_beatle_mario_bros)
    render_inline new_component(player:)

    assert_selector "[title='Current']", count: 0
  end

  private

  def assert_current_phase(phase)
    assert_selector "[title='Current']" do |element|
      element.ancestor("summary").has_text?(phase)
    end
  end
end
