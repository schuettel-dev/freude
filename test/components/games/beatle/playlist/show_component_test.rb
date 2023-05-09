require "test_helper"

class Games::Beatle::Playlist::ShowComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)

    render_inline new_component(playlist:)

    assert_selector "h2", text: "My playlist"
    assert_selector "iframe", count: 3
    assert_link "Close playlist", href: url_helpers.game_path(game)
  end
end
