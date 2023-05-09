require "test_helper"

class Games::Beatle::CollectingPhaseComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render" do
    game = games(:beatle_seinfeld)
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "h2", text: "My playlist"
    assert_link "Show playlist", href: url_helpers.edit_game_beatle_playlist_path(game, player.playlist)
  end
end
