class Games::GroupNameComponent < ApplicationComponent
  def initialize(game:)
    @game = game
    super()
  end

  def call
    tag.h1 game.group_name, id: to_dom_id, class: "text-5xl mb-8"
  end

  def to_dom_id
    dom_id(game, :group_name)
  end

  private

  attr_reader :game
end
