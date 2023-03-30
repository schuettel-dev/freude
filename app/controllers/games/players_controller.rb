class Games::PlayersController < ApplicationController
  before_action :set_and_authorize_game

  def index
    @player = find_game.players.for_user(Current.user).first
  end

  private

  def set_and_authorize_game
    authorize find_game, :show?
  end

  def find_game
    @find_game ||= policy_scope(Game).find_by!(url_identifier: params[:game_id])
  end
end
