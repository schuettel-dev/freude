require "application_system_test_case"

class GameTest < ApplicationSystemTestCase
  test "starts a new game" do
    sign_in :mario

    click_on "New game"

    assert_selector "h1", text: "All games"

    within_game_template_section "Beatle" do
      assert_text "Guess who's behind a playlist of 3 songs"
      click_on "Start this game"
    end

    fill_in "Group name", with: "All stars"
    click_on "Ready!"

    assert_selector "h1", text: "All stars"
  end

  test "owner edits a game" do
    sign_in :mario

    goto_game "Mario Bros"
    click_on "Edit game"
    fill_in "Group name", with: "Luigi Bros"
    click_on "Update game"

    assert_selector "h1", text: "Luigi Bros"
  end

  private

  def goto_game(group_name)
    within_game(group_name) do
      click_on "Goto game"
    end
  end

  def within_game_template_section(game_name, &)
    game_title = find "h2", text: game_name
    within(game_title.ancestor("section"), &)
  end

  def within_game(group_name, &)
    group_title = find "h2", text: group_name
    within(group_title.ancestor("section"), &)
  end
end
