require "application_system_test_case"

class Games::Beatle::Game::EndedPhaseTest < ApplicationSystemTestCase
  test "owner visits game in ended phase" do
    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      assert_selector "h2", text: "FINAL RANKING"
      assert_selector "h2", text: "FINAL RESULTS"
      assert_selector "h2", text: "ADMIN"

      assert_no_selector "h2", text: "PLAYERS"
      assert_no_selector "h2", text: "PHASES"
    end
  end
end
