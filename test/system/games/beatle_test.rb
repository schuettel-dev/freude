require "application_system_test_case"

class Games::BeatleTest < ApplicationSystemTestCase
  test "owner cannot change state to :guessing if not enough players" do
    players(:peach_player_in_beatle_mario_bros).destroy!
    sign_in :mario
    goto_game "Mario Bros"

    within_game_section "Admin" do
      assert_no_link_or_button "Proceed to Guessing phase"
    end
  end

  test "owner changes state to guessing" do
    sign_in :mario
    goto_game "Mario Bros"

    assert_selector ".games--state-badge", text: "Collecting"

    within_game_section "Admin" do
      click_on "Proceed to Guessing phase"
    end

    assert_selector ".games--state-badge", text: "Guessing"
  end
end
