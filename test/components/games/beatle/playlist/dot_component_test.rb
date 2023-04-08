require "test_helper"

class Games::Beatle::Playlist::DotComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render, current playlist" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    render_inline(new_component(playlist:, current_playlist: playlist)) { "X" }

    assert_selector "span", text: "X" do |element|
      assert_equal "Jerry", element["title"]
    end
  end

  test "render, not current playlist" do
    current_playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    render_inline(new_component(playlist:, current_playlist:)) { "X" }

    assert_link "X", href: url_helpers.game_beatle_playlist_path(playlist.game, playlist) do |element|
      assert_equal "Jerry", element["title"]
    end
  end
end
