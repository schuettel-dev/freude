class GameInstance < ApplicationRecord
  belongs_to :user
  belongs_to :game

  before_validation :initialize_state, if: :new_record?
  before_validation :initialize_token, if: :new_record?

  validates :group_name, :state, :type, :token, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user:) }

  private

  def initialize_state
    return unless self.class.respond_to?(:states)

    self.state ||= self.class.states.keys.first
  end

  def initialize_token
    self.token ||= SecureRandom.alphanumeric(5)
  end
end
