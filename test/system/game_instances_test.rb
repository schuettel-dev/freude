require "application_system_test_case"

class GameInstancesTest < ApplicationSystemTestCase
  test "starts a new game" do
    sign_in :mario

    click_on "New game"

    assert_selector "h1", text: "Games"

    within_game_section "Beatle" do
      assert_text "Guess who's behind a playlist of 3 songs"
      click_on "Start this game"
    end

    fill_in "Group name", with: "All stars"
    click_on "Ready!"

    assert_selector "h1", text: "All stars"
  end

  private

  def within_game_section(game_name, &)
    game_title = find "h2", text: game_name
    within(game_title.ancestor("section"), &)
  end
end
