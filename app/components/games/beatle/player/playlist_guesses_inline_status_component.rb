class Games::Beatle::Player::PlaylistGuessesInlineStatusComponent < ApplicationComponent
  def initialize(player:)
    @player = player
  end

  def ordered_playlist_guesses
    @ordered_playlist_guesses ||= player.playlist_guesses.ordered
  end

  def css_classes(bool)
    class_names(
      "w-3 h-3 rounded-full",
      bool ? "bg-blue-500" : "bg-gray-200"
    )
  end

  private

  attr_reader :player
end
