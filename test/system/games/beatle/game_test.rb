require "application_system_test_case"

class Games::Beatle::GameTest < ApplicationSystemTestCase
  test "user starts a new game" do
    using_browser do
      sign_in :jerry

      click_on "New game"

      assert_selector "h1", text: "All games"

      within_game_template_section "BEATLE" do
        assert_text "Guess who's behind a playlist of 3 songs"
        click_on "Start this game"
      end

      assert_link "Back to all games", href: "/game_templates"

      click_on "I changed my mind..."

      within_game_template_section "BEATLE" do
        click_on "Start this game"
      end

      assert_selector "h2", text: "BEATLE"
      assert_button "Ready!"

      click_on "Ready!"

      assert_selector ".text-red-400", text: "can't be blank"

      fill_in "Group name", with: "All stars"
      click_on "Ready!"

      assert_selector "h1", text: "All stars"
      assert_selector "h2", text: "PHASES"
      assert_selector "h2", text: "1 PLAYER"
      assert_selector "h2", text: "ADMIN"
    end
  end
end
