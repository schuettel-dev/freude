require "test_helper"

class Games::Beatle::CurrentPhaseSectionComponentTest < ViewComponent::TestCase
  test "render, collecting phase" do
    games(:beatle_seinfeld).collecting!
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_show_playlist_link
    assert_selector "section", count: 1
    assert_selector ".games--beatle--playlist--inline-status-component", count: 1
  end

  test "render, guessing phase" do
    games(:beatle_seinfeld).guessing!
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_show_playlist_link
    assert_selector "section", count: 2
    assert_selector ".games--beatle--playlist--inline-status-component", count: 0
  end

  test "render, ended phase" do
    games(:beatle_seinfeld).guessing!
    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_selector "section", count: 2
    assert_selector ".games--beatle--playlist--inline-status-component", count: 0
    assert_show_playlist_link
  end

  private

  def assert_show_playlist_link
    assert_link "Show playlist", href: "/games/BEATLEJERRYURLIDENTIFIER/beatle/playlist"
  end
end
