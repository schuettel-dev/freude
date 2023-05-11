require "test_helper"

class Games::Beatle::AllPlaylistGuessesInlineStatusComponentTest < ViewComponent::TestCase
  test "render, all playlists ready" do
    game = games(:beatle_seinfeld)
    render_inline new_component(game:)

    assert_selector ".conic-pie", class: "conic-pie-complete" do |element|
      assert_equal "12 / 12 guessed", element["title"]
    end
  end

  test "render, some playlists not ready" do
    games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).update(guessed_player: nil)
    game = games(:beatle_seinfeld)
    render_inline new_component(game:)

    assert_selector ".conic-pie", class: "conic-pie-incomplete" do |element|
      assert_equal "11 / 12 guessed", element["title"]
    end
  end
end
