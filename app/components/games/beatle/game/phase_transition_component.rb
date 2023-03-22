class Games::Beatle::Game::PhaseTransitionComponent < ApplicationComponent
  attr_reader :game, :phase, :user

  TEXTS = {
    backward: { button: "Return to this phase", info: "All data from this phase will be lost" },
    forward: { button: "Start this phase", info: "" }
  }.freeze

  def initialize(game:, phase:, user:)
    @game = game
    @phase = phase
    @user = user
  end

  def render?
    game.user == user && game.phase != phase.to_s && game.transition_allowed?(to_phase: phase)
  end

  def texts
    @texts ||= transition_backwards? ? TEXTS[:backward] : TEXTS[:forward]
  end

  private

  def transition_backwards?
    game.completed_phase?(phase)
  end
end
