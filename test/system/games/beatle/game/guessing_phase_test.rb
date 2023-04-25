require "application_system_test_case"

class Games::Beatle::Game::GuessingPhaseTest < ApplicationSystemTestCase
  test "user sees sections" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)

    sign_in :jerry
    goto_game "Seinfeld"

    assert_selector "h2", text: "Who's behind this playlist?"
    assert_selector "h2", text: "My playlist"
    assert_selector "h2", text: "Phases"
    assert_selector "h2", text: "4 Players"
  end

  test "user guesses the playlists" do
    using_browser do
      assert false, "TODO"
    end
  end
end
