class Game < ApplicationRecord
  attr_readonly :url_identifier

  belongs_to :user
  belongs_to :game_template

  has_many :players, dependent: :destroy
  has_many :players_users, through: :players, source: :user

  with_options if: :new_record? do
    before_validation(
      :initialize_type,
      :initialize_phase,
      :initialize_url_identifier,
      :initialize_join_token,
      :initialize_player
    )
  end

  validates :group_name, :phase, :type, :join_token, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(players: Player.for_user(user)) }

  def to_param
    url_identifier
  end

  def add_player(user:)
    players.find_or_initialize_by(user:)
  end

  def change_phase(to_phase)
    update(phase: to_phase) if transition_allowed?(to_phase:)
  end

  def transition_allowed?(to_phase:)
    phase.to_sym == to_phase.to_sym ||
      (self.class::ALLOWED_TRANSITIONS[phase.to_sym].include?(to_phase.to_sym) &&
        meets_preconditions_to_transit_to_phase?(to_phase:))
  end

  def next_phase
    self.class.phases.keys.then { _1[_1.index(phase).next]&.to_sym }
  end

  def next_phase?(other)
    next_phase == other.to_sym
  end

  def minimum_players_reached?
    players.count >= (game_template&.minimum_players || Float::INFINITY)
  end

  private

  def initialize_type
    self.type ||= [self.class, game_template&.class&.name&.demodulize].compact.join("::")
  end

  def initialize_phase
    self.phase ||= type.safe_constantize.try(:phases)&.keys&.first
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

  def meets_preconditions_to_transit_to_phase?(*)
    raise "implement in subclass"
  end
end
