require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "owner sees invitation section, if joining is still possible" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)

    sign_in :jerry

    goto_game "Seinfeld"

    within_game_card "Admin" do
      assert_field "URL to join", with: "http://www.example.com/games/BEATLEJERRYURLIDENTIFIER/join/BEATLEJERRYJOINTOKEN"
    end
  end

  test "owner does not see invitation section, if joining is not possible" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    sign_in :jerry

    goto_game "Seinfeld"

    assert_no_selector "h2", text: "Invite"
  end

  test "non-owner does not see the invite and admin section" do
    sign_in :elaine
    goto_game "Seinfeld"

    assert_no_selector "h2", text: "Invite"
    assert_no_selector "h2", text: "Admin"
  end

  test "owner edits a game" do
    using_browser do
      sign_in :jerry

      goto_game "Seinfeld"
      click_on "Edit game"
      fill_in "Group name", with: "Giddyup"
      click_on "Update game"

      assert_selector "h1", text: "Giddyup"
    end
  end

  test "owner deletes a game" do
    sign_in :jerry

    goto_game "Seinfeld"
    click_on "Delete game"

    assert_selector "h1", text: "My games"
    assert_no_selector "h2", text: "Seinfeld"
  end

  test "user joins game" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :newman
    visit game_join_url(game, token: game.join_token, host: "www.example.com")

    assert_selector "h1", text: "Seinfeld"
  end

  test "user tries to join game, has a wrong token" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :newman
    visit game_join_url(game, token: "WRONGTOKEN", host: "www.example.com")

    assert_selector "h1", text: "My games"
    assert_selector ".flashes", text: "Game couldn't be joined, the token was wrong."
  end

  test "guest opens joins game url, signs up first" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    visit game_join_url(game, token: game.join_token, host: "www.example.com")
    fill_in "Name", with: "Babu"
    click_on "Sign up"

    assert_selector "h1", text: "Seinfeld"
  end

  test "user opens joins game url, rejoins first" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :newman
    sign_out
    visit game_join_url(game, token: game.join_token, host: "www.example.com")
    click_on "Rejoin as Newman"

    assert_selector "h1", text: "Seinfeld"
  end

  test "user leaves game" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :kramer

    goto_game "Seinfeld"

    click_on "Leave game"

    assert_selector "h1", "Games"
  end
end
