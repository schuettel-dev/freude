require "test_helper"

class EmbeddedPlayerComponentTest < ViewComponent::TestCase
  test "render, valid spotify" do
    playlist = player_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    render_inline new_component(song_url: playlist.song_urls.first)

    assert_selector "iframe" do |element|
      assert_match %r{^https://open.spotify.com/embed/.*$}, element[:src]
    end
  end

  test "render, invalid" do
    playlist = player_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    render_inline new_component(song_url: playlist.song_urls.second)

    assert_no_selector "iframe"
  end

  test "render, blank" do
    playlist = player_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    render_inline new_component(song_url: playlist.song_urls.third)

    assert_no_selector "iframe"
  end
end
