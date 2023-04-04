class Games::Beatle::PlaylistGuess::PaginationComponent < ApplicationComponent
  delegate :game, to: :current_playlist_guess

  attr_reader :ordered_playlist_guesses, :current_playlist_guess

  def initialize(ordered_playlist_guesses, current_playlist_guess)
    @ordered_playlist_guesses = ordered_playlist_guesses
    @current_playlist_guess = current_playlist_guess
  end

  def previous_playlist_guess
    return if previous_playlist_guess_index.negative?

    ordered_playlist_guesses[previous_playlist_guess_index]
  end

  def next_playlist_guess
    return if next_playlist_guess_index >= ordered_playlist_guesses.size

    ordered_playlist_guesses[current_playlist_guess_index.next]
  end

  private

  def previous_playlist_guess_index
    @previous_playlist_guess_index ||= current_playlist_guess_index.pred
  end

  def current_playlist_guess_index
    @current_playlist_guess_index ||= ordered_playlist_guesses.index(current_playlist_guess)
  end

  def next_playlist_guess_index
    @current_playlist_guess_index ||= current_playlist_guess_index.next
  end
end
