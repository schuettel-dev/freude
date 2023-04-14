require "application_system_test_case"

class Games::Beatle::GameTest < ApplicationSystemTestCase
  test "user starts a new game" do
    using_browser do
      sign_in :jerry

      click_on "New game"

      assert_selector "h1", text: "All games"

      within_game_template_section "Beatle" do
        assert_text "Guess who's behind a playlist of 3 songs"
        click_on "Start this game"
      end

      fill_in "Group name", with: "All stars"
      click_on "Ready!"

      assert_selector "h1", text: "All stars"
      assert_selector "h2", text: "Phases"
      assert_selector "h2", text: "1 Player"
      assert_selector "h2", text: "Admin"
    end
  end
end
