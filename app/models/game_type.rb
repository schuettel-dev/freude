class GameType < ApplicationRecord
  has_many :games, dependent: :destroy

  validates :name, :description, :instance_type, presence: true
  validates :name, :instance_type, uniqueness: true

  scope :ordered, -> { order(name: :asc) }

  def new_game(user:)
    instance_type.constantize.new(game_type: self, user:)
  end
end
