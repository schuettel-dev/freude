require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
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
    assert_selector "h2", text: "Invite"
    assert_selector "h2", text: "1 Player"
    assert_selector "h2", text: "Admin"
  end

  test "owner sees invitation section" do
    sign_in :mario

    goto_game "Mario Bros"

    within_game_section "Invite" do
      assert_field "URL to join", with: "http://www.example.com/games/MARIOBROSURLIDENTIFIER/join/MARIOBROSJOINTOKEN"
    end
  end

  test "owner edits a game" do
    sign_in :mario

    goto_game "Mario Bros"
    click_on "Edit game"
    fill_in "Group name", with: "Luigi Bros"
    click_on "Update game"

    assert_selector "h1", text: "Luigi Bros"
  end

  test "owner deletes a game" do
    sign_in :mario

    goto_game "Mario Bros"
    click_on "Delete game"

    assert_selector "h1", text: "My games"
    assert_no_selector "h2", text: "Mario Bros"
  end

  test "non-owner cannot edit or delete a game" do
    sign_in :luigi
    goto_game "Mario Bros"

    assert_no_link "Edit game"
    assert_no_link "Delete game"
  end

  private

  def goto_game(group_name)
    within_game_list_item(group_name) do
      click_on "Goto game"
    end
  end

  def within_game_template_section(game_name, &)
    game_title_element = find "h2", text: game_name
    within(game_title_element.ancestor("section"), &)
  end

  def within_game_list_item(group_name, &)
    group_title_element = find "h2", text: group_name
    within(group_title_element.ancestor("section"), &)
  end

  def within_game_section(section_title, &)
    section_title_element = find "h2", text: section_title
    within(section_title_element.ancestor("section"), &)
  end
end
