class Games::Beatle::PlaylistGuess::DotComponent < ApplicationComponent
  attr_reader :playlist_guess, :current_playlist_guess

  def initialize(playlist_guess:, current_playlist_guess:)
    @playlist_guess = playlist_guess
    @current_playlist_guess = current_playlist_guess
  end

  def call
    if current_playlist_guess?
      tag.span(content, class: span_css_classes)
    else
      link_to(
        content,
        edit_game_beatle_playlist_guess_path(playlist_guess.game, playlist_guess),
        class: link_to_css_classes
      )
    end
  end

  private

  def current_playlist_guess?
    playlist_guess == current_playlist_guess
  end

  def span_css_classes
    class_names(
      common_css_classes,
      bg_css_classes,
      "outline outline-offset-2 outline-4",
      (playlist_guess.guessed? ? "outline-blue-600" : "outline-gray-500")
    )
  end

  def link_to_css_classes
    class_names(
      common_css_classes,
      bg_css_classes,
      "opacity-70 hover:opacity-100 transition"
    )
  end

  def common_css_classes
    "flex justify-center items-center text-xs w-8 h-8 rounded-full"
  end

  def bg_css_classes
    playlist_guess.guessed? ? "bg-blue-300" : "bg-gray-200"
  end
end
