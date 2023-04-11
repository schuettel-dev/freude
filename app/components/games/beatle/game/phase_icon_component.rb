class Games::Beatle::Game::PhaseIconComponent < ApplicationComponent
  PHASE_ICONS = {
    current: { icon: :clock, class: "w-6 h-6 text-blue-500", title: I18n.t("games.shared.current") },
    completed: { icon: :check, class: "w-6 h-6 text-green-500", title: I18n.t("games.shared.completed") }
  }.freeze

  def initialize(game:, phase:)
    @game = game
    @phase = phase
    super()
  end

  def render?
    icon.present?
  end

  def call
    render HeroiconComponent.new(icon[:icon], **icon.except(:icon))
  end

  private

  attr_reader :game, :phase

  def icon
    @icon ||= PHASE_ICONS[find_icon]
  end

  def find_icon
    return :completed if completed_phase?
    return :current if current_phase?
  end

  def current_phase?
    game.current_phase?(phase)
  end

  def completed_phase?
    game.completed_phase?(phase)
  end
end
