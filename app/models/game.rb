class Game < ApplicationRecord
  attr_readonly :url_identifier

  belongs_to :user
  belongs_to :game_template

  has_many :players, dependent: :destroy
  has_many :players_users, through: :players, source: :user

  with_options if: :new_record? do
    before_validation :initialize_url_identifier, :initialize_join_token
  end

  validates :name, :description, :group_name, :phase, :type,
            :minimum_players, :activated_players, :maximum_players, :join_token,
            presence: true

  with_options if: :phase_changed? do
    validate :validate_phase_transition_allowed
    validate :validate_phase_requirements

    before_save :transit_to_phase
  end

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(players: Player.for_user(user)) }

  def to_param
    url_identifier
  end

  def new_player(...)
    game_template.append_to_namespace(Player).new(...).tap do |player|
      player.setup
      players << player
    end
  end

  def phase_changed_callback
    raise "TODO"
  end

  def self.transition_allowed?(from_phase: nil, to_phase:)
    return first_phase.to_sym == to_phase.to_sym if from_phase.nil?

    self::ALLOWED_TRANSITIONS[from_phase.to_sym].include?(to_phase.to_sym)
  end

  def transition_allowed?(to_phase:)
    self.class.transition_allowed?(from_phase: phase, to_phase:)
  end

  def phases
    self.class.phases
  end

  def self.first_phase
    phases.keys.first
  end

  def self.last_phase
    phases.keys.last
  end

  def current_phase?(other)
    phase == other.to_s
  end

  def completed_phase?(other)
    ended? || phases.keys.index(other.to_s) < phases.keys.index(phase)
  end

  def next_phase
    self.class.phases.keys.then { _1[_1.index(phase).next]&.to_sym }
  end

  def next_phase?(other)
    next_phase == other.to_sym
  end

  def minimum_players_reached?
    players.count >= (minimum_players || Float::INFINITY)
  end

  def broadcast_group_names
    comp = Games::GroupNameComponent.new(game: self)
    broadcast_replace_to(self, target: comp.to_dom_id, html: ApplicationController.render(comp, layout: false))
  end

  private

  def initialize_url_identifier
    self.url_identifier ||= SecureRandom.alphanumeric(6)
  end

  def initialize_join_token
    self.join_token ||= SecureRandom.alphanumeric(5)
  end

  def validate_phase_transition_allowed
    return if self.class.transition_allowed?(from_phase: phase_was, to_phase: phase)

    errors.add(:base, :transition_not_allowed)
  end

  def validate_phase_requirements
    validate_phase_requirements_for(phase)
  end

  def validate_phase_requirements_for(phase)
    raise "implement in subclass"
  end

  def call_phase_method(to_phase:, method_type:) # rubocop:disable Metrics/MethodLength
    return unless to_phase.to_s.in?(phases.keys)

    method_name = case method_type.to_sym
                  when :requirements_met
                    "requirements_met_for_#{to_phase}_phase?"
                  when :prepare
                    "prepare_#{to_phase}_phase"
                  else
                    raise "Unknown method type '#{method_type}'"
                  end

    if respond_to?(method_name)
      send(method_name)
    else
      true
    end
  end

  def rank_players_with(&)
    Game::RankPlayersWith.new(self).call(&)
  end
end
