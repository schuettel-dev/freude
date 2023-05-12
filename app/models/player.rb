class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :of_game, ->(game) { where(game:) }
  scope :for_user, ->(user) { where(user:) }
  scope :order_by_user_name, -> { joins(:user).order("users.name ASC") }
  scope :order_by_final_rank, -> { order(final_rank: :asc, id: :asc) }
  scope :top, ->(number) { where(final_rank: 0..number) }

  validates :final_points, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :final_rank, numericality: { greater_than: 0 }, allow_nil: true

  def setup
    raise "implement in subclass"
  end

  def broadcast_phase_update
    broadcast_replace_component Games::CurrentPhaseSectionComponent.new(player: self)
    broadcast_replace_component Games::PhasesSectionComponent.new(player: self)
    broadcast_replace_component Games::PlayersSectionComponent.new(player: self)
    broadcast_replace_component Games::GeneralSectionComponent.new(player: self) if game_admin?
  end

  def broadcast_admin_phase_transition
    broadcast_replace_component Games::Beatle::AdminPhaseTransitionComponent.new(player: self)
  end

  def broadcast_players_section
    broadcast_replace_component Games::PlayersSectionComponent.new(player: self)
  end

  def game_admin?
    game.user == user
  end
end
