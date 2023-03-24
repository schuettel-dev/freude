class Games::Beatle::PlaylistGuess < ApplicationRecord
  belongs_to :player, class_name: "Player"
  belongs_to :guessing_player, class_name: "Player"
  belongs_to :guessed_player, class_name: "Player", optional: true

  scope :of_game, ->(game) { where(guessing_player: game.players) }
end
