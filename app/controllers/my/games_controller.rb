class My::GamesController < ApplicationController
  def index
    @games = policy_scope(GameInstance).ordered
  end

  def show
    @game = policy_scope(GameInstance).find(params[:id])
  end
end
