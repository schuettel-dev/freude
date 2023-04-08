require "test_helper"

class Games::Beatle::PlaylistGuess::DotComponentTest < ViewComponent::TestCase
  delegate :url_helpers, to: "Rails.application.routes"

  test "render, current playlist guess, guessed" do
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    render_inline(new_component(playlist_guess:, current_playlist_guess: playlist_guess)) { "42" }

    assert_selector "span", text: "42", class: "bg-blue-300"
  end

  test "render, current playlist guess, not guessed" do
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    playlist_guess.update!(guessed_player: nil)
    render_inline(new_component(playlist_guess:, current_playlist_guess: playlist_guess)) { "42" }

    assert_selector "span", text: "42", class: "bg-gray-200"
  end

  test "render, not current playlist guess, guessed" do
    current_playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_george)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    render_inline(new_component(playlist_guess:, current_playlist_guess:)) { "42" }

    assert_link "42", href: href_for(playlist_guess), class: "bg-blue-300"
  end

  test "render, not current playlist guess, not guessed" do
    current_playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_george)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)
    playlist_guess.update!(guessed_player: nil)
    render_inline(new_component(playlist_guess:, current_playlist_guess:)) { "42" }

    assert_link "42", href: href_for(playlist_guess), class: "bg-gray-200"
  end

  private

  def href_for(playlist_guess)
    url_helpers.edit_game_beatle_playlist_guess_path(playlist_guess.game, playlist_guess)
  end
end
