class My::GamesController < ApplicationController
  def index
    @game_instances = policy_scope(GameInstance).ordered
  end

  def show
    @game_instance = policy_scope(GameInstance).find_by!(url_identifier: params[:id])
  end
end
