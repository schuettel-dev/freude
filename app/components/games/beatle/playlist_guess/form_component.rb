class Games::Beatle::PlaylistGuess::FormComponent < ApplicationComponent
  attr_reader :playlist_guess

  delegate :player, to: :playlist_guess
  delegate :game, to: :player

  def initialize(playlist_guess:)
    @playlist_guess = playlist_guess
    super()
  end

  def ordered_playlist_guesses
    @ordered_playlist_guesses ||= player.playlist_guesses.ordered
  end

  def guessed_player_options
    game.players.having_playlist_ready_to_guess.without(player).order_by_user_name.map do |option_player|
      [to_label(option_player), option_player.id]
    end
  end

  def to_dom_id
    dom_id(player, :playlist_guess_form)
  end

  private

  def to_label(option_player)
    count = ordered_playlist_guesses.count { _1.guessed_player == option_player }

    [
      option_player.user.name,
      "(#{t("games.beatle.shared.selected_n_times", count:)})"
    ].compact.join(" ")
  end
end
