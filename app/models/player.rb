class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :for_user, ->(user) { where(user:) }
  scope :ordered_by_user_name, -> { joins(:user).order("users.name ASC") }

  def setup
    raise "implement in subclass"
  end
end
