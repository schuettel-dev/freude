require "test_helper"

class Games::Beatle::Playlist::PaginationComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render, two items, first is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlists(
      :jerry_player_in_beatle_seinfeld_playlist,
      :elaine_player_in_beatle_seinfeld_playlist
    )
    first, second = ordered_items

    render_inline new_component(ordered_items, first)

    assert_previous_link count: 0
    assert_next_link href: url_helpers.game_beatle_playlist_path(game, second)

    assert_current_pagination_item text: "J", title: "Jerry"
    assert_pagination_item_link text: "L", title: "Laney", href: url_helpers.game_beatle_playlist_path(game, second)
  end

  test "render, two items, second is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlists(
      :jerry_player_in_beatle_seinfeld_playlist,
      :elaine_player_in_beatle_seinfeld_playlist
    )
    first, second = ordered_items

    render_inline new_component(ordered_items, second)

    assert_previous_link href: url_helpers.game_beatle_playlist_path(game, first)
    assert_next_link count: 0

    assert_pagination_item_link text: "J", title: "Jerry", href: url_helpers.game_beatle_playlist_path(game, first)
    assert_current_pagination_item text: "L", title: "Laney"
  end

  test "render, three items, middle is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlists(
      :jerry_player_in_beatle_seinfeld_playlist,
      :elaine_player_in_beatle_seinfeld_playlist,
      :george_player_in_beatle_seinfeld_playlist
    )
    first, second, third = ordered_items

    render_inline new_component(ordered_items, second)

    assert_previous_link href: url_helpers.game_beatle_playlist_path(game, first)
    assert_next_link href: url_helpers.game_beatle_playlist_path(game, third)

    assert_pagination_item_link text: "J", title: "Jerry", href: url_helpers.game_beatle_playlist_path(game, first)
    assert_current_pagination_item text: "L", title: "Laney"
    assert_pagination_item_link text: "G", title: "George", href: url_helpers.game_beatle_playlist_path(game, third)
  end

  private

  def assert_previous_link(count: 1, href: nil)
    assert_link "Previous", count:, href:
  end

  def assert_next_link(count: 1, href: nil)
    assert_link "Next", count:, href:
  end

  def assert_pagination_item_link(text:, title:, href:)
    assert_link text, href: do |element|
      assert_equal title, element["title"]
    end
  end

  def assert_current_pagination_item(text:, title:)
    assert_selector "span", text: do |element|
      assert_equal title, element["title"]
    end
  end
end
