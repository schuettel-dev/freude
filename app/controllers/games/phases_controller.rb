class Games::PhasesController < ApplicationController
  before_action :set_and_authorize_game

  def show
    @player = @game.players.find_by!(user: Current.user)
  end

  def update
    form = Games::Beatle::Game::PhaseChangeForm.new(game: @game, params:)
    form.save

    redirect_to game_path(@game)
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game
  end
end
