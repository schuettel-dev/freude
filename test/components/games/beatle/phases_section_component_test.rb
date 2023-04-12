require "test_helper"

class Games::PhasesSectionComponentTest < ViewComponent::TestCase
  test "render, collecting" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)
    player = players(:elaine_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_current_phase "Collecting"
  end

  test "render, guessing" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    player = players(:elaine_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_current_phase "Guessing"
  end

  test "not render" do
    player = players(:elaine_player_in_beatle_seinfeld)

    assert_not_predicate new_component(player:), :render?
  end

  private

  def assert_current_phase(phase)
    assert_selector "[title='Current']" do |element|
      element.ancestor("summary").has_text?(phase)
    end
  end
end
