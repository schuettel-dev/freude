require "application_system_test_case"

class Games::Beatle::Game::EndedPhaseTest < ApplicationSystemTestCase
  test "owner visits game in ended phase" do
    sign_in :jerry
    goto_game "Seinfeld"

    assert_selector "h2", text: "Final ranking"
    assert_selector "h2", text: "Final results"
    assert_selector "h2", text: "General"
    assert_no_selector "h2", text: "Players"
    assert_no_selector "h2", text: "Phases"
  end

  test "player visits game in ended phase" do
    sign_in :elaine
    goto_game "Seinfeld"

    assert_selector "h2", text: "Final ranking"
    assert_selector "h2", text: "Final results"
    assert_no_selector "h2", text: "General"
    assert_no_selector "h2", text: "Players"
    assert_no_selector "h2", text: "Phases"
  end
end
