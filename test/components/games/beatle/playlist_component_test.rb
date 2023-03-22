require "test_helper"

class Games::Beatle::PlaylistComponentTest < ViewComponent::TestCase
  test "render, phase collecting" do
    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    user = users(:mario)

    render_inline new_component(playlist:, user:)

    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is valid", count: 1
    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is invalid", count: 1
    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is blank", count: 1

    assert_selector "iframe", count: 1
    assert_field "Song 1", with: "https://open.spotify.com/track/6lDyt5CQQAWnHhJyGczaBM?si=6a49db56dadc4a7c"
    assert_field "Song 2", with: "https://todo"
    assert_field "Song 3" do |field|
      assert_nil field.value
    end

    assert_button "Save playlist"
    assert_link "Close playlist"
  end

  test "render, phase guessing" do
    games(:beatle_mario_bros).guessing!

    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    user = users(:mario)

    render_inline new_component(playlist:, user:)

    assert_no_selector "input"
  end

  test "render, phase ended" do
    games(:beatle_mario_bros).ended!

    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)
    user = users(:mario)

    render_inline new_component(playlist:, user:)

    assert_no_selector "input"
  end
end
