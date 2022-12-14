class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  before_validation :initialize_type, if: :new_record?

  scope :for_user, ->(user) { where(user:) }
  scope :ordered_by_user_name, -> { joins(:user).order("users.name DESC") }

  private

  def initialize_type
    self.type ||= [self.class, game&.class&.name&.demodulize].compact.join("::")
  end
end
