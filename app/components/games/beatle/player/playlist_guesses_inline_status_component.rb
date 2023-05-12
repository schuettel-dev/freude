class Games::Beatle::Player::PlaylistGuessesInlineStatusComponent < ApplicationComponent
  DEFAULTS = {
    class: "w-8 h-8",
    hole_scale: 0.5,
    hole_color: "#fff"
  }.freeze

  def initialize(player:, **args)
    @player = player
    @args = DEFAULTS.dup.merge(args)
    super()
  end

  def call
    if player.playlist.ready_to_guess?
      render ConicPieComponent.new(guessed_percentage.round(5), **args.merge(title:, id: to_dom_id))
    else
      render HeroiconComponent.new(
        :"speaker-x-mark",
        class: "w-8 h-8 text-gray-300",
        title: t("games.beatle.shared.empty_playlist")
      )
    end
  end

  def to_dom_id
    dom_id(player, :playlist_guesses_inline_status)
  end

  private

  attr_reader :player, :args

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
    @playlist_guesses ||= player.playlist_guesses
  end
end
