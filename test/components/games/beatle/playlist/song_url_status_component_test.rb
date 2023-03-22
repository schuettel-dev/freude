require "test_helper"

class Games::Beatle::Playlist::SongUrlStatusComponentTest < ViewComponent::TestCase
  setup do
    @playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
  end

  test "render, valid" do
    song_url = @playlist.song_urls.first
    render_inline new_component(song_url:)

    assert_selector ".games--beatle--playlist--song-url-status", count: 1, text: "URL is valid"
  end

  test "render, invalid" do
    song_url = @playlist.song_urls.second
    render_inline new_component(song_url:)

    assert_selector ".games--beatle--playlist--song-url-status", count: 1, text: "URL is invalid"
  end

  test "render, blank" do
    song_url = @playlist.song_urls.third
    render_inline new_component(song_url:)

    assert_selector ".games--beatle--playlist--song-url-status", count: 1, text: "URL is blank"
  end
end
