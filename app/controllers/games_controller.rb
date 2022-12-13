class GamesController < ApplicationController
  def index
    @games = policy_scope(Game).ordered
  end

  def show
    @game = policy_scope(Game).find_by!(url_identifier: params[:id])
  end
end
