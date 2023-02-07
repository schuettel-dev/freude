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
end
