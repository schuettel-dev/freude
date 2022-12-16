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

  test "user joins game" do
    game = games(:beatle_mario_bros)
    sign_in :toad
    visit game_join_url(game, token: game.join_token, host: "www.example.com")

    assert_selector "h1", text: "Mario Bros"
  end

  test "user tries to join game, has a wrong token" do
    game = games(:beatle_mario_bros)
    sign_in :toad
    visit game_join_url(game, token: "WRONGTOKEN", host: "www.example.com")

    assert_selector "h1", text: "My games"
    assert_selector ".flashes", text: "Game couldn't be joined, the token was wrong."
  end

  test "guest opens joins game url, signs up first" do
    game = games(:beatle_mario_bros)
    visit game_join_url(game, token: game.join_token, host: "www.example.com")
    fill_in "Name", with: "Koopa"
    click_on "Sign up"

    assert_selector "h1", text: "Mario Bros"
  end

  test "user opens joins game url, rejoins first" do
    game = games(:beatle_mario_bros)
    sign_in :toad
    sign_out
    visit game_join_url(game, token: game.join_token, host: "www.example.com")
    click_on "Rejoin as Toad"

    assert_selector "h1", text: "Mario Bros"
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
