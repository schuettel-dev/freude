class Games::CataloguesController < ApplicationController
  def show
    @game_templates = GameTemplate.ordered
  end
end
