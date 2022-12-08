class GamesController < ApplicationController
  def index
    @games = Game.ordered
  end
end
