require "application_system_test_case"

class Games::Beatle::Game::CollectingPhaseTest < ApplicationSystemTestCase
  setup do
    games(:beatle_seinfeld).update_column(:phase, :collecting)
  end

  test "owner visits game in collecting phase" do
    sign_in :jerry
    goto_game "Seinfeld"

    assert_selector "h2", text: "My playlist"
    assert_selector "h2", text: "Phases"
    assert_selector "h2", text: "Players"
    assert_selector "h2", text: "General"
  end

  test "player visits game in collecting phase" do
    sign_in :elaine
    goto_game "Seinfeld"

    assert_selector "h2", text: "My playlist"
    assert_selector "h2", text: "Phases"
    assert_selector "h2", text: "Players"
    assert_selector "h2", text: "General"
  end

  test "owner cannot change phase to :guessing if not enough players" do
    players(:george_player_in_beatle_seinfeld, :kramer_player_in_beatle_seinfeld).map(&:destroy!)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "PHASES" do
        assert_current_phase "Collecting"

        assert_text "There aren't enough players and Not enough players have guessed playlists"
        assert_button "Start guessing phase", disabled: true
      end
    end
  end

  test "owner changes phase to guessing" do
    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      assert_selector "h2", text: "MY PLAYLIST"
      assert_no_selector "h2", text: "WHO'S BEHIND THIS PLAYLIST"

      accept_confirm("Are you sure?") do
        within_game_card "PHASES" do
          assert_current_phase "Collecting"

          click_on "Start guessing phase"
        end
      end

      assert_selector "h2", text: "MY PLAYLIST"
      assert_selector "h2", text: "WHO'S BEHIND THIS PLAYLIST?"

      within_game_card "PHASES" do
        assert_current_phase "Guessing"
      end

      within_game_card "GENERAL" do
        assert_no_field
      end
    end
  end

  test "player submits their songs" do
    player = players(:elaine_player_in_beatle_seinfeld)
    player.playlist.reset_song_urls

    using_browser do
      sign_in :elaine
      goto_game "Seinfeld"

      within_game_card "MY PLAYLIST" do
        click_on "Show playlist"
      end

      assert_urls blank: 3, valid: 0, invalid: 0

      fill_in "Song 1", with: "https://wrong"
      click_on "Save"

      assert_urls blank: 2, valid: 0, invalid: 1

      fill_in "Song 1", with: "https://open.spotify.com/track/7mfzrDtsheZEKZBhyViHih"
      click_on "Save"

      assert_urls blank: 2, valid: 1, invalid: 0

      fill_in "Song 2", with: "https://open.spotify.com/track/5VPgzslOy3admlCpj5W6X5"
      fill_in "Song 3", with: "https://open.spotify.com/track/6qb76Rj7bFYI4ZafAYlH96"

      click_on "Save"

      assert_urls blank: 0, valid: 3, invalid: 0
    end
  end

  test "player sees new player joining, and then leaving" do
    other_user_session = Capybara::Session.new(:selenium_headless)

    game = games(:beatle_seinfeld)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "PLAYERS" do
        assert_selector ".games--beatle--players-section-component--players-count", text: "4 Players"
      end

      other_user_session.visit game_join_url(game, token: game.join_token)
      other_user_session.fill_in "Name", with: "Babu"
      other_user_session.click_on "Sign up"

      within_game_card "PLAYERS" do
        assert_selector ".games--beatle--players-section-component--players-count", text: "5 Players"
      end

      other_user_session.accept_confirm("Are you sure?") do
        other_user_session.click_on "Leave game"
      end

      within_game_card "PLAYERS" do
        assert_selector ".games--beatle--players-section-component--players-count", text: "4 Players"
      end
    end
  end

  test "player get updated if phase changed to collecting" do
    game = games(:beatle_seinfeld)
    player = players(:jerry_player_in_beatle_seinfeld)

    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      assert_no_selector "h2", text: "WHO'S BEHIND THIS PLAYLIST?"
      assert_selector "h2", text: "MY PLAYLIST"
      assert_selector "h2", text: "PLAYERS"

      game.update_column(:phase, :guessing)
      player.broadcast_phase_update

      assert_selector "h2", text: "WHO'S BEHIND THIS PLAYLIST?"
      assert_selector "h2", text: "MY PLAYLIST"
      assert_selector "h2", text: "PLAYERS"
    end
  end

  test "submitting a playlist changes inline status components" do
    using_browser do
      sign_in :jerry
      goto_game "Seinfeld"

      within_game_card "PLAYERS" do
        assert_selector ".games--beatle--all-playlists-inline-status-component" do |element|
          assert_equal "All playlists are ready to guess", element["title"]
        end
        assert_no_selector ".games--beatle--playlist--inline-status-component .text-gray-500"
        assert_no_selector ".games--beatle--playlist--inline-status-component .text-red-500"
      end

      within_game_card "MY PLAYLIST" do
        click_on "Show playlist"
      end

      within_game_card "MY PLAYLIST" do
        fill_in "Song 1", with: "https://wrong"
        fill_in "Song 2", with: ""
        click_on "Save playlist"
      end

      within_game_card "PLAYERS" do
        assert_selector ".games--beatle--all-playlists-inline-status-component" do |element|
          assert_equal "1 playlist is incomplete", element["title"]
        end
        assert_selector ".games--beatle--playlist--inline-status-component .text-gray-500"
        assert_selector ".games--beatle--playlist--inline-status-component .text-red-400"
      end
    end
  end

  private

  def assert_urls(blank:, valid:, invalid:)
    css_selector = ".games--beatle--playlist--song-url-status"

    assert_selector css_selector, count: blank + valid + invalid
    assert_selector css_selector, text: "URL is blank", exact_text: true, count: blank
    assert_selector css_selector, text: "URL is valid", exact_text: true, count: valid
    assert_selector css_selector, text: "URL is invalid", exact_text: true, count: invalid
  end

  def assert_current_phase(phase)
    assert_selector "[title='Current']" do |element|
      element.ancestor("summary").has_text?(phase)
    end
  end
end
