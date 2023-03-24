class Games::Beatle::Game::PhaseTransitionComponent < ApplicationComponent
  attr_reader :game, :phase, :user

  def initialize(game:, phase:, user:)
    @game = game
    @phase = phase
    @user = user
    super()
  end

  def render?
    game.user == user && game.phase != phase.to_s && game.transition_allowed?(to_phase: phase)
  end

  def texts
    @texts ||= transition_backwards? ? t("games.phase_transitions.backward") : t("games.phase_transitions.forward")
  end

  def transition_blocked?
    !game.requirements_met_for_phase?(to_phase: phase)
  end

  private

  def transition_backwards?
    game.completed_phase?(phase)
  end
end
