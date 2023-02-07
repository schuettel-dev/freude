require "application_system_test_case"

class Games::BeatleTest < ApplicationSystemTestCase
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
    sign_in :luigi
    goto_game "Mario Bros"

    within_game_section "My songs" do
      assert_selector "submission--state", text: "3 of 3 songs missing"

      click_on "Add song #1"
      fill_in "Song URL", with: "https://open.spotify.com/track/7mfzrDtsheZEKZBhyViHih"
      click_on "Save"

      assert_selector "submission--state", text: "2 of 3 songs missing"

      click_on "Add song #2"
      fill_in "Song URL", with: "https://open.spotify.com/track/5VPgzslOy3admlCpj5W6X5"
      click_on "Save"

      assert_selector "submission--state", text: "1 of 3 songs missing"

      click_on "Add song #3"
      fill_in "Song URL", with: "https://open.spotify.com/track/6qb76Rj7bFYI4ZafAYlH96"
      click_on "Save"

      assert_selector "submission--state", text: "Yay, you are all set!"

      click_on "Edit song 3"
      fill_in "Song URL", with: "https://open.spotify.com/track/7rxIaq6w64bfUdKmr5WKkn"
      click_on "Save"

      assert_selector "submission--state", text: "Yay, you are all set!"
    end
  end
end
