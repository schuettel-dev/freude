require "test_helper"

class Games::Beatle::PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test "GET show" do
    sign_in :jerry
    game = games(:beatle_seinfeld)
    game.collecting!
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    get edit_game_beatle_playlist_path(game, playlist)

    assert_response :success
  end

  test "PUT update" do
    sign_in :jerry
    game = games(:beatle_seinfeld)
    game.collecting!
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)

    assert_changes -> { playlist.song_2_url }, to: "https://something.else" do
      put game_beatle_playlist_path(game, playlist), params: {
        games_beatle_playlist: {
          song_2_url: "https://something.else"
        }
      }
      playlist.reload
    end

    follow_redirect!

    assert_response :success
  end
end
