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

  test "user shows own playlist" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "MY PLAYLIST" do
        click_on "Show playlist"
      end

      within_game_card "MY PLAYLIST" do |elm|
        assert_selector "iframe", count: 3

        click_on "Close playlist"
      end

      within_game_card "MY PLAYLIST" do
        click_on "Show playlist"
      end
    end
  end

  test "user guesses the playlists" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    players(:jerry_player_in_beatle_seinfeld).playlist_guesses.update_all(guessed_player_id: nil)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "WHO'S BEHIND THIS PLAYLIST?" do
        assert_selector ".games--beatle--playlist-guess--dot-component.current-playlist-guess", text: "1"
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 0
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 3
        assert_no_link "1"
        assert_link "2"
        assert_link "3"

        select "George (Selected 0 times)", from: "Guessed player"
        click_on "Save guess"

        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 1
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 2

        click_on "Next"

        assert_selector ".games--beatle--playlist-guess--dot-component.current-playlist-guess", text: "2"
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 1
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 2
        assert_link "1"
        assert_no_link "2"
        assert_link "3"

        select "Kramer (Selected 0 times)", from: "Guessed player"
        click_on "Save guess"

        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 2
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 1

        click_on "Next"

        assert_selector ".games--beatle--playlist-guess--dot-component.current-playlist-guess", text: "3"
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 2
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 1
        assert_link "1"
        assert_link "2"
        assert_no_link "3"

        select "Laney (Selected 0 times)", from: "Guessed player"
        click_on "Save guess"

        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-guessed", count: 3
        assert_selector ".games--beatle--playlist-guess--dot-component.playlist-unguessed", count: 0

        assert_select(
          "Guessed player",
          options: [
            "Pick your guess...",
            "George (Selected 1 time)",
            "Kramer (Selected 1 time)",
            "Laney (Selected 1 time)"
          ]
        )
      end
    end
  end

  test "guessing a playlist changes the conic pie" do
    skip "TODO"
  end

  test "owner changes phase to collecting" do
    using_browser do
      assert false, "TODO"
    end
  end

  test "owner changes phase to ended" do
    using_browser do
      assert false, "TODO"
    end
  end
end
