require "test_helper"

class Games::Beatle::Playlist::ShowResolvedComponentTest < ViewComponent::TestCase
  test "render, default" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)

    render_inline new_component(playlist:, current_player: player)

    assert_selector "iframe", count: 3
  end

  # own playlist
  test "render, own playlist, no one guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id)

    render_inline new_component(playlist:, current_player: player)

    assert_text "No one got that right!"
    assert_text "It was believed it belonged to"
  end

  test "render, own playlist, multiple guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: player.id)
    playlist.guesses.first.update!(guessed_player: other_player)

    render_inline new_component(playlist:, current_player: player)

    assert_text "2 players got that right!"
    assert_text "It was believed it belonged to"
  end

  test "render, own playlist, all guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: player.id)

    render_inline new_component(playlist:, current_player: player)

    assert_text "Everyone got that right!"
    assert_no_text "It was believed it belonged to"
  end

  # other playlist
  test "render, other playlist, no one guessed it right" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id)

    render_inline new_component(playlist:, current_player: player)

    assert_text "No one got that right!"
    assert_text "It was believed it belonged to"
  end

  test "render, other playlist, multiple guessed it right" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: playlist.player.id)
    playlist.guesses.find_by(player:).update!(guessed_player: other_player)

    render_inline new_component(playlist:, current_player: player)

    assert_text "2 players got that right!"
    assert_text "You thought it was George."
    assert_text "It was believed it belonged to"
  end

  test "render, other playlist, all guessed it right" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: playlist.player.id)

    render_inline new_component(playlist:, current_player: player)

    assert_text "Everyone got that right!"
  end
end
