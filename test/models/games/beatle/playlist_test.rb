require "test_helper"

class Games::Beatle::PlaylistTest < ActiveSupport::TestCase
  test "#song_urls" do
    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)

    playlist.song_urls.tap do |song_urls|
      assert_equal :valid, song_urls[0].status
      assert_equal :invalid, song_urls[1].status
      assert_equal :blank, song_urls[2].status
    end
  end

  test "#reset_song_urls" do
    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)

    playlist.reset_song_urls

    assert_nil playlist.song_1_url
    assert_nil playlist.song_2_url
    assert_nil playlist.song_3_url
  end

  test "#set_ready_to_guess, #ready_to_guess" do
    playlist = games_beatle_playlists(:mario_player_in_beatle_mario_bros_playlist)

    assert_changes -> { playlist.reload.ready_to_guess? }, to: false do
      playlist.update!(song_1_url: "https://wrong")
    end
  end
end
