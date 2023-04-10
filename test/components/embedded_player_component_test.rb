require "test_helper"

class EmbeddedPlayerComponentTest < ViewComponent::TestCase
  setup do
    @playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
  end

  test "render, valid spotify" do
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_selector "iframe" do |element|
      assert_match %r{^https://open.spotify.com/embed/.*$}, element[:src]
    end
  end

  test "render, invalid" do
    @playlist.song_1_url = "https://something"
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_no_selector "iframe"
  end

  test "render, blank" do
    @playlist.song_1_url = ""
    render_inline new_component(song_url: @playlist.song_urls.first)

    assert_no_selector "iframe"
  end
end
