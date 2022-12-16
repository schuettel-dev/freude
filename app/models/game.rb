class Game < ApplicationRecord
  attr_readonly :url_identifier

  belongs_to :user
  belongs_to :game_template

  has_many :players, dependent: :destroy
  has_many :players_users, through: :players, source: :user

  with_options if: :new_record? do
    before_validation(
      :initialize_type,
      :initialize_state,
      :initialize_url_identifier,
      :initialize_join_token,
      :initialize_player
    )
  end

  validates :group_name, :state, :type, :join_token, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(players: Player.for_user(user)) }

  def to_param
    url_identifier
  end

  def add_player(user:)
    players.find_or_initialize_by(user:)
  end

  private

  def initialize_type
    self.type ||= [self.class, game_template&.class&.name&.demodulize].compact.join("::")
  end

  def initialize_state
    self.state ||= type.safe_constantize.try(:states)&.keys&.first
  end

  def initialize_url_identifier
    self.url_identifier ||= SecureRandom.alphanumeric(6)
  end

  def initialize_join_token
    self.join_token ||= SecureRandom.alphanumeric(5)
  end

  def initialize_player
    add_player(user:)
  end
end
