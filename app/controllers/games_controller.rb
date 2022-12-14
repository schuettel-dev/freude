class GamesController < ApplicationController
  prepend_before_action :store_after_sign_in_redirect_to_url, only: :join

  before_action :set_and_authorize_game, except: [:index, :join]
  before_action :set_and_authorize_game_for_join, only: [:join]

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

  def destroy
    @game.destroy
    redirect_to root_path
  end

  def join
    if correct_game_token?
      @game.add_player(user: Current.user)
      @game.save
      redirect_to @game.becomes(Game)
    else
      flash[:notice] = t(".could_not_join_game_due_to_wrong_token")
      redirect_to root_path
    end
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:id])
    authorize @game
  end

  def set_and_authorize_game_for_join
    @game = Game.find_by!(url_identifier: params[:game_id])
    authorize @game
  end

  def game_params
    params.require(:game).permit(:group_name)
  end

  def correct_game_token?
    params[:token].present? && params[:token] == @game.join_token
  end
end
