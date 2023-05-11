class Games::Beatle::AllPlaylistGuessesInlineStatusComponent < ApplicationComponent
  def initialize(game:)
    @game = game
    super()
  end

  def call
    render ConicPieComponent.new(guessed_percentage, class: css_classes, hole_scale: 0.4, title:, id: to_dom_id)
  end

  def to_dom_id
    dom_id(game, :all_playlist_guesses_inline_status)
  end

  private

  attr_reader :game

  def css_classes
    "w-6 h-6 #{to_css_class}"
  end

  def title
    t("games.beatle.shared.x_out_of_y_guessed", x: guessed_guesses_count, y: total_guesses_count)
  end

  def guessed_percentage
    @guessed_percentage ||= guessed_guesses_count.to_f / total_guesses_count * 100
  end

  def guessed_guesses_count
    @guessed_guesses_count ||= playlist_guesses.guessed.size
  end

  def total_guesses_count
    @total_guesses_count ||= playlist_guesses.size
  end

  def playlist_guesses
    @playlist_guesses ||= game.playlist_guesses
  end
end
