class Games::Beatle::Game::PhaseTransitionComponent < ApplicationComponent
  attr_reader :game, :user

  def initialize(game:, user:)
    @game = game
    @user = user
    @transition_error_messages = {}
    super()
  end

  def render?
    game.user == user
  end

  def display_error_messages_for(phase)
    return if transition_error_messages(:ended).none?

    tag.span(transition_error_messages(:ended).to_a.join(", "), class: "flex justify-center text-sm text-red-500")
  end

  def transition_error_messages(phase)
    @transition_error_messages[phase.to_sym] ||= errors_if_transitioned_to_phase(phase.to_sym)
  end

  private

  def errors_if_transitioned_to_phase(phase)
    game.phase = phase
    game.validate
    errors = game.errors
    game.restore_attributes
    errors
  end
end
