class GamesController < ApplicationController
  before_action :set_and_authorize_game, except: :index

  def index
    @games = policy_scope(Game).ordered
  end

  def show; end

  def edit; end

  def update
    if @game.update(game_params)
      redirect_to @game.becomes(Game)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:id])
    authorize @game
  end

  def game_params
    params.require(:game).permit(:group_name)
  end
end
