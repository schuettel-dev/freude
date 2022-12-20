class GameTemplate < ApplicationRecord
  has_many :games, dependent: :destroy

  validates :name, :image_path, :description, :minimum_players, :url_identifier, :type, presence: true
  validates :name, :url_identifier, :type, uniqueness: true

  scope :ordered, -> { order(name: :asc) }

  def to_partial_path
    "game_templates/game_template"
  end
end
