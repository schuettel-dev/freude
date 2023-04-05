class Games::Beatle::PlaylistGuess < ApplicationRecord
  delegate :game, :user, to: :player

  belongs_to :player, class_name: "Player"
  belongs_to :guessing_player, class_name: "Player"
  belongs_to :guessed_player, class_name: "Player", optional: true

  scope :of_game, ->(game) { joins(:player).where(players: { game: }) }
  scope :for_user, ->(user) { joins(:player).where(players: { user: }) }
  scope :guessed, -> { where.not(guessed_player: nil) }
  scope :unguessed, -> { where(guessed_player: nil) }
  scope :right_guessed, -> { where("guessed_player_id = guessing_player_id") }
  scope :wrong_guessed, -> { where("guessed_player_id != guessing_player_id") }
  scope :ordered, -> { order(:id) }

  validates :points, inclusion: [0, 1]
  validates :guessing_player_id, uniqueness: { scope: :player_id }

  def guessed?
    guessed_player.present?
  end
end
