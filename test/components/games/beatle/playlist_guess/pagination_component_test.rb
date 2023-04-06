require "test_helper"

class Games::Beatle::PlaylistGuess::PaginationComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render, two items, first is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlist_guesses(
      :jerry_player_in_beatle_seinfeld_guessing_elaine,
      :jerry_player_in_beatle_seinfeld_guessing_george
    )
    first, second = ordered_items

    render_inline new_component(ordered_items, first)

    assert_previous_link count: 0
    assert_next_link href: url_helpers.edit_game_beatle_playlist_guess_path(game, second)

    assert_current_pagination_item text: "1"
    assert_pagination_item_link text: "2", href: url_helpers.edit_game_beatle_playlist_guess_path(game, second)
  end

  test "render, two items, second is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlist_guesses(
      :jerry_player_in_beatle_seinfeld_guessing_elaine,
      :jerry_player_in_beatle_seinfeld_guessing_george
    )
    first, second = ordered_items

    render_inline new_component(ordered_items, second)

    assert_previous_link href: url_helpers.edit_game_beatle_playlist_guess_path(game, first)
    assert_next_link count: 0

    assert_pagination_item_link text: "1", href: url_helpers.edit_game_beatle_playlist_guess_path(game, first)
    assert_current_pagination_item text: "2"
  end

  test "render, three items, middle is current" do
    game = games(:beatle_seinfeld)
    ordered_items = games_beatle_playlist_guesses(
      :jerry_player_in_beatle_seinfeld_guessing_elaine,
      :jerry_player_in_beatle_seinfeld_guessing_george,
      :jerry_player_in_beatle_seinfeld_guessing_kramer
    )
    first, second, third = ordered_items

    render_inline new_component(ordered_items, second)

    assert_previous_link href: url_helpers.edit_game_beatle_playlist_guess_path(game, first)
    assert_next_link href: url_helpers.edit_game_beatle_playlist_guess_path(game, third)

    assert_pagination_item_link text: "1", href: url_helpers.edit_game_beatle_playlist_guess_path(game, first)
    assert_current_pagination_item text: "2"
    assert_pagination_item_link text: "3", href: url_helpers.edit_game_beatle_playlist_guess_path(game, third)
  end

  private

  def assert_previous_link(count: 1, href: nil)
    assert_link "Previous", count:, href:
  end

  def assert_next_link(count: 1, href: nil)
    assert_link "Next", count:, href:
  end

  def assert_pagination_item_link(text:, href:)
    assert_link text, href:
  end

  def assert_current_pagination_item(text:)
    assert_selector "span", text:
  end
end
