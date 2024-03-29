require "test_helper"

class Games::Beatle::Player::PlaylistGuessesInlineStatusComponentTest < ViewComponent::TestCase
  test "render, custom arguments" do
    player = players(:jerry_player_in_beatle_seinfeld)

    render_inline new_component(player:, class: "w-10 h-10", hole_scale: 0.6, hole_color: "tomato")

    assert_selector "div" do |element|
      assert_match(/--conic-pie-percent: 100.0%;/, element["style"])
      assert_match(/--conic-pie-hole-scale: 0.6;/, element["style"])
      assert_match(/--conic-pie-hole-color: tomato;/, element["style"])
      assert_equal "3 / 3 guessed", element["title"]
    end
  end

  test "render, incomplete guesses" do
    player = players(:jerry_player_in_beatle_seinfeld)
    games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).update!(guessed_player: nil)

    render_inline new_component(player:, class: "w-10 h-10")

    assert_selector "div" do |element|
      assert_match(/--conic-pie-percent: 66.66667%;/, element["style"])
      assert_match(/--conic-pie-hole-scale: 0.5;/, element["style"])
      assert_match(/--conic-pie-hole-color: #fff;/, element["style"])
      assert_equal "2 / 3 guessed", element["title"]
    end
  end

  test "render, empty playlist" do
    player = players(:jerry_player_in_beatle_seinfeld)
    player.playlist.reset_song_urls
    player.playlist_guesses.destroy_all

    render_inline new_component(player:, class: "w-10 h-10")

    assert_selector "div", match: :first do |element|
      assert_equal "Empty playlist", element["title"]
    end
  end
end
