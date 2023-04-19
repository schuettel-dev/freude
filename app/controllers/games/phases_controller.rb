class Games::PhasesController < ApplicationController
  before_action :set_and_authorize_game

  def show
    @player = @game.players.find_by!(user: Current.user)
  end

  def update
    form = Games::Beatle::Game::PhaseChangeForm.new(game: @game, params:)
    form.save

    respond_to do |format|
      format.html { redirect_to game_path(@game) }
      format.turbo_stream do
        @game.broadcast_phase_update
      end
    end
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game
  end
end
