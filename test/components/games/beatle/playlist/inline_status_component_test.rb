require "test_helper"

class Games::Beatle::Playlist::InlineStatusComponentTest < ViewComponent::TestCase
  test "render" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    render_inline new_component(playlist:)

    assert_selector "svg", count: 3
  end
end
