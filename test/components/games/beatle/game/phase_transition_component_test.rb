require "test_helper"

class Games::Beatle::Game::PhaseTransitionComponentTest < ViewComponent::TestCase
  test "not render, if not owner" do
    game = games(:beatle_seinfeld)
    user = users(:elaine)
    component = new_component(game:, user:)

    assert_not component.render?
  end

  test "render, collecting phase, valid" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    user = users(:jerry)
    render_inline new_component(game:, user:)

    assert_button "Start guessing phase" do |element|
      assert_equal "Are you sure?", element["data-turbo-confirm"]
    end
  end

  test "render, collecting phase, invalid" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)

    user = users(:jerry)
    render_inline new_component(game:, user:)

    assert_button "Start guessing phase", disabled: true

    assert_text "There aren't enough players"
  end

  test "render, guessing phase, valid" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)
    players(
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).map(&:destroy!)
    user = users(:jerry)
    render_inline new_component(game:, user:)

    assert_button "Go back to collecting phase" do |element|
      assert_equal "Are you sure? Player's guesses will reset.", element["data-turbo-confirm"]
    end

    assert_button "End game" do |element|
      assert_equal "This will end the game, you cannot undo this.", element["data-turbo-confirm"]
    end
  end

  test "render, guessing phase, invalid" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)
    games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine).update!(guessed_player: nil)
    user = users(:jerry)
    render_inline new_component(game:, user:)

    assert_button "Go back to collecting phase" do |element|
      assert_equal "Are you sure? Player's guesses will reset.", element["data-turbo-confirm"]
    end

    assert_button "End game", disabled: true

    assert_text "Not all players have casted all of their guesses"
  end
end
