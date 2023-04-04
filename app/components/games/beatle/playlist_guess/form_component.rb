class Games::Beatle::PlaylistGuess::FormComponent < ApplicationComponent
  attr_reader :playlist_guess

  delegate :player, to: :playlist_guess
  delegate :game, to: :player

  def initialize(playlist_guess:)
    @playlist_guess = playlist_guess
  end

  def ordered_playlist_guesses
    @ordered_playlist_guesses ||= player.playlist_guesses.ordered
  end

  def guessed_player_options
    game.players.without(player).order_by_user_name.map do |option_player|
      [to_label(option_player), option_player.id]
    end
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
