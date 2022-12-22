class Games::StatesController < ApplicationController
  before_action :set_and_authorize_game

  def update
    unless @game.change_state(params[:state].presence)
      # TODO
    end

    redirect_to game_path(@game)
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game, :update_state?
  end
end
