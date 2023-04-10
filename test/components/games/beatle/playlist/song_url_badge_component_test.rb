require "test_helper"

class Games::Beatle::Playlist::SongUrlBadgeComponentTest < ViewComponent::TestCase
  setup do
    @playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
  end

  test "render, valid spotify" do
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_selector "div", class: "text-green-600"
  end

  test "render, invalid" do
    @playlist.song_1_url = "https://something"
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_selector "div", class: "text-red-400"
  end

  test "render, blank" do
    @playlist.song_1_url = ""
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_selector "div", class: "text-gray-500"
  end
end
