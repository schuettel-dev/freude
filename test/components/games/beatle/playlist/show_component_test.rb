require "test_helper"

class Games::Beatle::Playlist::ShowComponentTest < ViewComponent::TestCase
  test "render, default" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)

    render_inline new_component(playlist:, player:)

    assert_selector "iframe", count: 3
  end

  # own playlist
  test "render, own playlist, no one guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id) # rubocop:disable Rails/SkipsModelValidations

    render_inline new_component(playlist:, player:)

    assert_text "No one got that right!"
    assert_text "They thought it belonged to"
    assert_match(/George[\n ]*3x/, page.native.text)
  end

  test "render, own playlist, one guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.first.update!(guessed_player: playlist.player)

    render_inline new_component(playlist:, player:)

    assert_text "Only someone got that right!"
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*2x/, page.native.text)
  end

  test "render, own playlist, multiple guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.first.update!(guessed_player: other_player)

    render_inline new_component(playlist:, player:)

    assert_text "2 players got that right!"
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*1x/, page.native.text)
  end

  test "render, own playlist, all guessed it right" do
    playlist = games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: player.id) # rubocop:disable Rails/SkipsModelValidations

    render_inline new_component(playlist:, player:)

    assert_text "Everyone got that right!"
    assert_no_text "The rest thought it belonged to"
  end

  # other playlist
  test "render, other playlist, no one guessed it right" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id) # rubocop:disable Rails/SkipsModelValidations

    render_inline new_component(playlist:, player:)

    assert_text "No one got that right!"
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*3x/, page.native.text)
  end

  test "render, other playlist, one guessed it right, not current player" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.where.not(player:).first.update!(guessed_player: playlist.player)

    render_inline new_component(playlist:, player:)

    assert_text "Only someone got that right, but not you!"
    assert_text "You thought it was George."
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*2x/, page.native.text)
  end

  test "render, other playlist, one guessed it right, current player" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: other_player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.find_by(player:).update!(guessed_player: playlist.player)

    render_inline new_component(playlist:, player:)

    assert_text "Only you got that right!"
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*2x/, page.native.text)
  end

  test "render, other playlist, multiple guessed it right, excluding current player" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: playlist.player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.find_by(player:).update!(guessed_player: other_player)

    render_inline new_component(playlist:, player:)

    assert_text "2 players got that right, but not you!"
    assert_text "You thought it was George."
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*1x/, page.native.text)
  end

  test "render, other playlist, multiple guessed it right, including current player" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    other_player = players(:george_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: playlist.player.id) # rubocop:disable Rails/SkipsModelValidations
    playlist.guesses.where.not(player:).first.update!(guessed_player: other_player)

    render_inline new_component(playlist:, player:)

    assert_text "2 players got that right, including you!"
    assert_text "The rest thought it belonged to"
    assert_match(/George[\n ]*1x/, page.native.text)
  end

  test "render, other playlist, all guessed it right" do
    playlist = games_beatle_playlists(:elaine_player_in_beatle_seinfeld_playlist)
    player = players(:jerry_player_in_beatle_seinfeld)
    playlist.guesses.update_all(guessed_player_id: playlist.player.id) # rubocop:disable Rails/SkipsModelValidations

    render_inline new_component(playlist:, player:)

    assert_text "Everyone got that right!"
  end
end
