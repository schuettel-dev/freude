require "test_helper"

class Games::Beatle::Playlist::EditComponentTest < ViewComponent::TestCase
  test "render, phase collecting" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    playlist.update!(
      song_2_url: "https://something",
      song_3_url: nil
    )

    render_inline new_component(playlist:)

    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is valid", count: 1
    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is invalid", count: 1
    assert_selector ".games--beatle--playlist--song-url-status", text: "URL is blank", count: 1

    assert_selector "iframe", count: 1
    assert_field "Song 1", with: "https://open.spotify.com/track/64VP3skE86iTvdOlbzuIcO?si=4975357312494fb8"
    assert_field "Song 2", with: "https://something"
    assert_field "Song 3" do |field|
      assert_nil field.value
    end

    assert_button "Save playlist"
    assert_link "Close playlist"
  end
end
