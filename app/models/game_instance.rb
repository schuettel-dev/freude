class GameInstance < ApplicationRecord
  attr_readonly :url_identifier

  belongs_to :user
  belongs_to :game

  has_many :players

  with_options if: :new_record? do
    before_validation(
      :initialize_state,
      :initialize_url_identifier,
      :initialize_token,
      :initialize_player
    )
  end

  validates :group_name, :state, :type, :token, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user:) }

  def to_param
    url_identifier
  end

  private

  def initialize_state
    return unless self.class.respond_to?(:states)

    self.state ||= self.class.states.keys.first
  end

  def initialize_url_identifier
    self.url_identifier ||= SecureRandom.alphanumeric(6)
  end

  def initialize_token
    self.token ||= SecureRandom.alphanumeric(5)
  end

  def initialize_player
    players.find_or_initialize_by(user:)
  end
end
