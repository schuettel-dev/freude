class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :of_game, ->(game) { where(game:) }
  scope :for_user, ->(user) { where(user:) }
  scope :ordered_by_user_name, -> { joins(:user).order("users.name ASC") }

  validates :final_points, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :final_rank, numericality: { greater_than: 0 }, allow_nil: true

  def setup
    raise "implement in subclass"
  end
end
