class GameTemplatesController < ApplicationController
  def index
    @game_templates = GameTemplate.ordered
  end
end
