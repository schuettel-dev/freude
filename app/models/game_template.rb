class GameTemplate < ApplicationRecord
  include UrlIdentifiable

  has_many :games, dependent: :destroy

  validates :name, :description,
            :minimum_players, :free_players, :maximum_players,
            :url_identifier, :namespace,
            presence: true
  validates :name, :url_identifier, :namespace, uniqueness: true

  scope :ordered, -> { order(name: :asc) }

  def to_partial_path
    "game_templates/game_template"
  end

  def new_game(...)
    append_to_namespace(Game).new(...).tap do |game|
      game.name = name
      game.description = description
      game.game_template = self
      game.minimum_players = minimum_players
      game.activated_players = free_players
      game.maximum_players = maximum_players
    end
  end

  def append_to_namespace(klass)
    namespace.split("::").append(klass.to_s).join("::").safe_constantize
  end
end
