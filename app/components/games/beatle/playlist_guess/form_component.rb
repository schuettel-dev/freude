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
end
