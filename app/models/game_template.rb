class GameTemplate < ApplicationRecord
  has_many :games, dependent: :destroy

  validates :name, :image_path, :description, :minimum_players, :url_identifier, :namespace, presence: true
  validates :name, :url_identifier, :namespace, uniqueness: true

  scope :ordered, -> { order(name: :asc) }

  def to_partial_path
    "game_templates/game_template"
  end

  def new_game(...)
    append_to_namespace(Game).new(...).tap do |game|
      game.game_template = self
    end
  end

  def append_to_namespace(klass)
    namespace.split("::").append(klass.to_s).join("::").safe_constantize
  end
end
