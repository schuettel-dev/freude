require "test_helper"

class Games::Beatle::AllPlaylistsInlineStatusComponentTest < ViewComponent::TestCase
  test "render, all playlists ready" do
    game = games(:beatle_seinfeld)
    render_inline new_component(game:)

    assert_selector ".text-green-600", count: 3
    assert_selector "div", match: :first do |element|
      assert_equal "All playlists are ready to guess", element["title"]
    end
  end

  test "render, not all playlists ready" do
    games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist).update_column(:song_1_url, nil)
    game = games(:beatle_seinfeld)
    render_inline new_component(game:)

    assert_selector ".text-indigo-400", count: 2
    assert_selector ".text-gray-300", count: 1
    assert_selector "div", match: :first do |element|
      assert_equal "1 playlist is incomplete", element["title"]
    end
  end
end
