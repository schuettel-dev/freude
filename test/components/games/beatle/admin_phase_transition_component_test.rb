require "test_helper"

class Games::Beatle::AdminPhaseTransitionComponentTest < ViewComponent::TestCase
  test "not render, if not owner" do
    player = players(:elaine_player_in_beatle_seinfeld)
    component = new_component(player:)

    assert_not component.render?
  end

  test "render, collecting phase, valid" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)

    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_button "Start guessing phase" do |element|
      assert_equal "Are you sure?", element["data-turbo-confirm"]
    end
  end

  test "render, collecting phase, invalid" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)

    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)

    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_button "Start guessing phase", disabled: true

    assert_text "There aren't enough players"
  end

  test "render, collecting phase, warning because incomplete playlists" do
    games(:beatle_seinfeld).update_column(:phase, :collecting)

    games_beatle_playlists(:jerry_player_in_beatle_seinfeld_playlist).update(song_1_url: nil)

    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_button "Start guessing phase" do |element|
      assert_equal "Are you sure?", element["data-turbo-confirm"]
    end

    assert_text "Warning: There are still empty or incomplete playlists."
    assert_text "Players with empty playlists will be excluded in the guessing phase."
  end


  test "render, guessing phase, valid" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)

    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)

    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_button "Go back to collecting phase" do |element|
      assert_equal "Are you sure? Player's guesses will reset.", element["data-turbo-confirm"]
    end

    assert_button "End game" do |element|
      assert_equal "This will end the game, you cannot undo this.", element["data-turbo-confirm"]
    end
  end

  test "render, guessing phase, invalid" do
    games(:beatle_seinfeld).update_column(:phase, :guessing)
    games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).update!(guessed_player: nil)

    player = players(:jerry_player_in_beatle_seinfeld)
    render_inline new_component(player:)

    assert_button "Go back to collecting phase" do |element|
      assert_equal "Are you sure? Player's guesses will reset.", element["data-turbo-confirm"]
    end

    assert_button "End game", disabled: true

    assert_text "Not all players have casted all of their guesses"
  end
end
