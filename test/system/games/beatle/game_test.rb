require "application_system_test_case"

class Games::Beatle::GameTest < ApplicationSystemTestCase
  test "owner cannot change phase to :guessing if not enough players" do
    players(:peach_player_in_beatle_mario_bros).destroy!
    sign_in :mario
    goto_game "Mario Bros"

    within_game_section "Admin" do
      assert_no_link_or_button "Proceed to Guessing phase"
    end
  end

  test "owner changes phase to guessing" do
    skip "to be implemented"

    sign_in :mario
    goto_game "Mario Bros"

    within_game_section "Phases" do
      assert_selector "details[open]", text: "Collecting"
    end

    within_game_section "Admin" do
      click_on "Proceed to Guessing phase"
    end

    within_game_section "Phases" do
      assert_selector "details[open]", text: "Guessing"
    end
  end

  test "player submits their songs" do
    player = players(:luigi_player_in_beatle_mario_bros)
    player.playlist.reset_song_urls

    sign_in :luigi
    goto_game "Mario Bros"

    within_game_section "My playlist" do
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

  private

  def assert_urls(blank:, valid:, invalid:)
    css_selector = ".games--beatle--playlist--song-url-status"

    assert_selector css_selector, count: blank + valid + invalid
    assert_selector css_selector, text: "URL is blank", exact_text: true, count: blank
    assert_selector css_selector, text: "URL is valid", exact_text: true, count: valid
    assert_selector css_selector, text: "URL is invalid", exact_text: true, count: invalid
  end
end
