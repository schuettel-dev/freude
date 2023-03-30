class Games::Beatle::PlaylistGuess < ApplicationRecord
  belongs_to :player, class_name: "Player"
  belongs_to :guessing_player, class_name: "Player"
  belongs_to :guessed_player, class_name: "Player", optional: true

  scope :of_game, ->(game) { where(guessing_player: game.players) }
  scope :unguessed, -> { where(guessed_player: nil) }
  scope :ordered, -> { order(:id) }

  validates :points, inclusion: [0, 1]
  validates :guessing_player_id, uniqueness: { scope: :player_id }

  def guessed?
    guessed_player.present?
  end
end
