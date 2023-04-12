require "test_helper"

class Games::Beatle::CurrentPhaseSectionComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render, collecting phase" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_show_playlist_link(player)
    assert_selector "section", count: 1
    assert_inline_status_component
  end

  test "render, guessing phase" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_show_playlist_link(player)
    assert_selector "section", count: 1
    assert_selector "turbo-frame##{dom_id(player, :playlist_guess)}"
    assert_inline_status_component count: 0
  end

  test "render, ended phase" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "section", count: 1
    assert_selector "turbo-frame##{dom_id(player, :playlist_guess)}"
    assert_inline_status_component count: 0
    assert_show_playlist_link(player)
  end

  private

  def assert_show_playlist_link(player)
    playlist = player.playlist

    assert_link "Show playlist", href: url_helpers.edit_game_beatle_playlist_path(playlist.game, playlist)
  end

  def assert_inline_status_component(count: 1)
    assert_selector ".games--beatle--player--playlist-inline-status-component", count:
  end
end
