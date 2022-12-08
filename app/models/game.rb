class Game < ApplicationRecord
  has_many :game_instances, dependent: :destroy

  validates :name, :image_path, :description, :url_identifier, :type, presence: true
  validates :name, :url_identifier, :type, uniqueness: true

  scope :ordered, -> { order(name: :asc) }

  def new_game_instance(params = {})
    game_instances.new(params.merge(type: "GameInstance::#{self.class.name.demodulize}"))
  end
end
