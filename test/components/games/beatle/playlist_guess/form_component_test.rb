require "test_helper"

class Games::Beatle::PlaylistGuess::FormComponentTest < ViewComponent::TestCase
  test "render" do
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    render_inline new_component(playlist_guess:)

    assert_selector "iframe", count: 3
    assert_selector "select" do |element|
      assert_equal(
        ["Pick your guess...", "George (Selected 1 time)", "Kramer (Selected 1 time)", "Laney (Selected 1 time)"],
        element.find_css("option").map(&:text)
      )
    end
    assert_selector "input[type='submit']" do |element|
      assert_equal "Save guess", element["value"]
    end
  end
end
