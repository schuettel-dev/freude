class Game < ApplicationRecord
  belongs_to :user
  belongs_to :game_type

  validates :name, :state, :type, presence: true

  validates :type, inclusion: { in: Proc.new { GameType.pluck(:instance_type) } }
end