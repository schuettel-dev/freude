class Games::Beatle::AdminPhaseTransitionComponent < ApplicationComponent
  delegate :game, to: :player

  def initialize(player:)
    @player = player
    @transition_error_messages = {}
    super()
  end

  def render?
    game.user == player.user
  end

  def display_error_messages_for(phase)
    return if transition_error_messages(phase).none?

    tag.span(transition_error_messages(phase).to_a.to_sentence, class: "flex justify-center text-sm text-red-500")
  end

  def transition_error_messages(phase)
    @transition_error_messages[phase.to_sym] ||= errors_if_transitioned_to_phase(phase.to_sym)
  end

  def to_dom_id
    dom_id(game, :admin_phase_transition)
  end

  private

  attr_reader :player

  def errors_if_transitioned_to_phase(phase)
    form = Games::Beatle::Game::PhaseChangeForm.new(game:, params: { phase: })
    form.validate
    form.errors
  end
end
