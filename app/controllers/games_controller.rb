class GamesController < ApplicationController
  prepend_before_action :store_after_sign_in_redirect_to_url, only: :join

  before_action :set_and_authorize_game, except: [:index, :new, :create, :join, :leave]
  before_action :set_and_authorize_game_for_join, only: [:join]
  before_action :set_and_authorize_game_for_leave, only: [:leave]

  def index
    @games = policy_scope(Game).ordered
  end

  def show
    @player = @game.players.find_by!(user: Current.user)
  end

  def new
    game_template = GameTemplate.find_by!(url_identifier: params[:game_template_id])
    @game = game_template.new_game
  end

  def edit; end

  def create
    game_template = GameTemplate.find(game_params[:game_template_id])

    @game = game_template.new_game(game_params.merge(user: Current.user))
    @game.new_player(user: Current.user)

    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      @game.broadcast_group_names
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
    return redirect_to game_path(@game) if @game.players.exists?(user: Current.user)

    return handle_join_with_correct_token if correct_game_token?

    flash[:notice] = t(".could_not_join_game_due_to_wrong_token")
    redirect_to root_path
  end

  def leave
    @game.players.find_by(user: Current.user).destroy
    @game.broadcast_all_players_section
    redirect_to games_path
  end

  private

  def set_and_authorize_game
    @game ||= policy_scope(Game).find_by!(url_identifier: params[:id])
    authorize @game
  end

  def set_and_authorize_game_for_join
    @game ||= Game.find_by!(url_identifier: params[:game_id])
    authorize @game
  end

  def set_and_authorize_game_for_leave
    @game ||= policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game
  end

  def game_params
    params.require(:game).permit(:game_template_id, :group_name)
  end

  def correct_game_token?
    params[:token].present? && params[:token] == @game.join_token
  end

  def handle_join_with_correct_token
    @game.new_player(user: Current.user).save
    @game.broadcast_all_players_section

    redirect_to @game.becomes(Game)
  end
end
