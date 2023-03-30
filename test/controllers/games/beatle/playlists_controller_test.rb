require "test_helper"

class Games::Beatle::PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test "GET show" do
    sign_in(:mario)
    game = games(:beatle_mario_bros)
    get edit_game_beatle_playlist_path(game)

    assert_response :success
  end

  test "PUT update" do
    sign_in(:mario)
    game = games(:beatle_mario_bros)
    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)

    assert_changes -> { playlist.song_2_url }, to: "https://something.else" do
      put game_beatle_playlist_path(game), params: {
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
