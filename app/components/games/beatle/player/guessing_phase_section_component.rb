class Games::Beatle::Player::GuessingPhaseSectionComponent < ApplicationComponent
  def initialize(player:)
    super()
    @player = player
  end

  def first_playlist_guess
    @first_playlist_guess ||= player.playlist_guesses.ordered.first
  end

  private

  attr_reader :player
end
