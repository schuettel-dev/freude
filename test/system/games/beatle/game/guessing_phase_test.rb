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

      within_game_card "MY PLAYLIST" do
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
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    players(:jerry_player_in_beatle_seinfeld).playlist_guesses.update_all(guessed_player_id: nil)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      conic_pie_for "Jerry" do |element|
        assert_equal "0 / 3 guessed", element["title"]
      end

      within_game_card "WHO'S BEHIND THIS PLAYLIST?" do
        select "George (Selected 0 times)", from: "Guessed player"
        click_on "Save guess"
      end

      conic_pie_for "Jerry" do |element|
        assert_equal "1 / 3 guessed", element["title"]
      end
    end
  end

  test "owner changes phase to collecting" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      accept_confirm("Are you sure? Player's guesses will reset.") do
        within_game_card "PHASES" do
          assert_current_phase "Guessing"

          click_on "Go back to collecting phase"
        end
      end

      assert_selector "h2", text: "MY PLAYLIST"

      within_game_card "PHASES" do
        assert_current_phase "Collecting"
      end
    end
  end

  test "owner changes phase to ended" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      accept_confirm("This will end the game, you cannot undo this.") do
        within_game_card "PHASES" do
          assert_current_phase "Guessing"

          click_on "End game"
        end
      end

      assert_selector "h2", text: "FINAL RANKING"
      assert_selector "h2", text: "FINAL RESULTS"
    end
  end

  test "owner cannot change phase to ended if preconditions are not met" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)

    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    playlist_guess.update!(guessed_player: nil)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "PHASES" do
        assert_current_phase "Guessing"

        assert_button "End game", disabled: true
        assert_text "Not all players have casted all of their guesses"
      end

      playlist_guess.update!(guessed_player: players(:elaine_player_in_beatle_seinfeld))
      game.broadcast_admin_phase_transition

      within_game_card "PHASES" do
        assert_button "End game"
      end
    end
  end

  private

  def assert_current_phase(phase)
    assert_selector "[title='Current']" do |element|
      element.ancestor("summary").has_text?(phase)
    end
  end

  def conic_pie_for(name, &)
    within_game_card "4 PLAYERS" do
      yield find("li", text: name).find(".conic-pie")
    end
  end
end
